//
//  ProcessInfoUtility.c
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

#include <sys/sysctl.h>
#include "ProcessInfoUtility.h"

uid_t uidFromPid(pid_t pid)
{
    uid_t uid = -1;

    struct kinfo_proc process;
    size_t procBufferSize = sizeof(process);

    // Compose search path for sysctl. Here you can specify PID directly.
    const u_int pathLenth = 4;
    int path[pathLenth] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};

    int sysctlResult = sysctl(path, pathLenth, &process, &procBufferSize, NULL, 0);

    // If sysctl did not fail and process with PID available - take UID.
    if ((sysctlResult == 0) && (procBufferSize != 0))
    {
        uid = process.kp_eproc.e_ucred.cr_uid;
        
    }

    return uid;
}
