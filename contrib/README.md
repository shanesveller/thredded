Requires [Vagrant](http://vagrantup.com/) and [Ansible](http://www.ansibleworks.com/)

Provides:
- Ubuntu 12.04
- Phusion Passenger + Nginx
- Redis
- PostgreSQL
- Thredded
- ~~Resque~~

``` shell
brew install brew-cask
brew cask install vagrant
brew install ansible
cd contrib
vagrant up
```

When the provisioning is done, visit http://localhost:8080/ to visit the VM's
copy of Thredded.
