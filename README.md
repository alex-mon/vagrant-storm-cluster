# Storm 1.0 Cluster

This vagrant file will deploy a Storm cluster with a Nimbus node and up to 9 Supervisor nodes.

By default, the Nimbus node will have 1GB of Ram and the Supervisor nodes will have 2Gb of ram and 2 executors

In order to change the number of Supervisor nodes, you will need to edit the *VagrantFile* and change the parameter named *cluster_size*

>cluster_size = 1

###The default ips and fqdn for the nodes are:
  - **Nimbus:** 
    - storm-master.cluster
    - 192.168.0.10
  - **Supervisor nodes:**  
    - node-x.cluster       
    - 192.168.0.1x *Where "x" is the node number*

# How to create the cluster using Vagrant and VirtualBox

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads "VirtualBox Downloads")
2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html "Vagrant Downloads")
3. Open a console and navigate to the folder where the *Vagrantfile* file is located
4. Run the command `vagrant up` to launch the machines creation and provision.
5. Once the process finishes, the storm cluster should be up and running, you can check the status through the [Storm-UI](http://192.168.0.10:8080/index.html "Storm UI") 
6. It's possible to suspend and resume the cluster machines using the commands `vagrant suspend` and `vagrant resume`
7. To ssh into the nodes: `ssh node-x.cluster`
8. To destroy the cluster use the command `vagrant destroy`

# Managing storm inside the cluster
Storm is installed in the path `/usr/lib/storm`, the logs can be found in `/var/log/storm` and the config in `/etc/storm` which is a link to `/usr/lib/storm/conf`

To start/stop the storm services:
- Nimbus (master node) `service storm-nimbus start/stop/status`
- UI (master node) `service storm-ui start start/stop/status`
- Supervisor (worker nodes) `service storm-supervisor start start/stop/status`
- Logviewer (worker nodes) `service storm-logviewer start start/stop/status`
