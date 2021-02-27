//
//  ProcessInfoUtility.h
//  ProcessExplorer
//
//  Created by Prashant Gautam on 27/02/21.
//

#ifndef ProcessInfoUtility_h
#define ProcessInfoUtility_h

#include <stdio.h>
struct process_cred {
    uid_t uid;
    pid_t ppid;
};

struct process_cred processCred(pid_t pid);

#endif /* ProcessInfoUtility_h */
