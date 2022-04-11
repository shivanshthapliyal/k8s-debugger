# k8s-debugger
Extrememely Small | Containerised kubectl, bash, curl, jq, screen, vim, db-clients &amp; monitoring on alpine.

Build the debugger docker image:

    # Clone the repo
    git clone https://github.com/shivanshthapliyal/k8s-debugger.git
    # Build docker image
    docker build -t debugger:v1.0.0 -f Dockerfile .


To add a container of debugger to your pods as a sidecar, add the following to your deployment:

    - name: debugger
      image: debugger:v1.0.0
      args:
       - <command-to-test>


  
