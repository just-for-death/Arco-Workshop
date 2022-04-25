#include <stdio.h>
#include <windows.h>

// SuspendThread or ResumeThread
typedef DWORD threadfunc_t(HANDLE);

#if 1 // TinyCC compatibility
	#define TH32CS_SNAPTHREAD 0x00000004

	typedef struct {
		DWORD dwSize;
		DWORD cntUsage;
		DWORD th32ThreadID;
		DWORD th32OwnerProcessID;
		LONG  tpBasePri;
		LONG  tpDeltaPri;
		DWORD dwFlags;
	} THREADENTRY32;
	typedef THREADENTRY32 *LPTHREADENTRY32;

	HANDLE CreateToolhelp32Snapshot(DWORD, DWORD);
	BOOL Thread32First(HANDLE, LPTHREADENTRY32);
	BOOL Thread32Next(HANDLE, LPTHREADENTRY32);
#endif

// https://stackoverflow.com/questions/11010165/how-to-suspend-resume-a-process-in-windows
BOOL ThreadAction(DWORD pid, threadfunc_t action)
{
	BOOL found = FALSE;
	// Ignore Wine warnings
	HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);

	THREADENTRY32 entry; 
	entry.dwSize = sizeof(THREADENTRY32);

	Thread32First(snapshot, &entry);
	do {
		if (entry.th32OwnerProcessID != pid)
		continue;

		found = TRUE;
		HANDLE thread = OpenThread(THREAD_ALL_ACCESS, FALSE,
			entry.th32ThreadID);

		if (action(thread) == -1)
			printf("Action failed. TID=%d, Error=%d\n", thread, GetLastError());

		CloseHandle(thread);
	} while (Thread32Next(snapshot, &entry));

	CloseHandle(snapshot);
	return found; // As long the thread lives
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		puts("Usage: suspend_start.exe \"C:/path/to/app.exe\" [\"args ...\"]");
		return 1;
	}

	// https://docs.microsoft.com/en-us/windows/win32/procthread/creating-processes
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	memset(&si, 0, sizeof(si));
	memset(&pi, 0, sizeof(pi));

	BOOL success = CreateProcessA(
		argv[1], // Application name
		argc >= 3 ? argv[2] : NULL,
		NULL, NULL, // Security
		FALSE,
		CREATE_SUSPENDED,
		NULL,
		NULL, // Current directory. Is it needed?
		&si, &pi
	);

	if (!success) {
		puts("Failed to start app. Path not found?");
		return 1;
	}

	printf("Success! Handle=%p, PID=%d, TID=%d\n", pi.hProcess, pi.dwProcessId, pi.dwThreadId);
	for (int i = 0; TRUE; ++i) {
		printf("% 4d | Proc suspended. ENTER to resume\n", i);
		getchar();
		if (!ThreadAction(pi.dwProcessId, ResumeThread))
			break;

		printf("% 4d | Proc resumed. ENTER to suspend\n", i);
		getchar();
		if (!ThreadAction(pi.dwProcessId, SuspendThread))
			break;
	}
	puts("END. Lost process.");
	return 0;
}