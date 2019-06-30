# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
	'balancer' => {'memory' => '256', 'cpus' => 1, 'ip' => '200', 'provision' => 'balancer.sh'},
	'master1' => {'memory' => '2048', 'cpus' => 2, 'ip' => '10', 'provision' => 'first-master.sh'},
	'master2' => {'memory' => '2048', 'cpus' => 2, 'ip' => '20', 'provision' => 'second-master.sh'},
	'master3' => {'memory' => '2048', 'cpus' => 2, 'ip' => '30', 'provision' => 'second-master.sh'},
	'minion1' => {'memory' => '1024', 'cpus' => 1, 'ip' => '101', 'provision' => 'minion.sh'},
	'minion2' => {'memory' => '1024', 'cpus' => 1, 'ip' => '102', 'provision' => 'minion.sh'},
	'minion3' => {'memory' => '1024', 'cpus' => 1, 'ip' => '103', 'provision' => 'minion.sh'}
}

Vagrant.configure('2') do |config|

	config.vm.box = 'debian/stretch64'
	config.vm.box_check_update = false

	vms.each do |name, conf|
		config.vm.define "#{name}" do |k|
		k.vm.hostname = "#{name}.k8s.com"
		k.vm.network 'private_network', ip: "27.11.90.#{conf['ip']}"
		k.vm.provider 'virtualbox' do |vb|
			vb.memory = conf['memory']
			vb.cpus = conf['cpus']
		end
		k.vm.provider 'libvirt' do |lv|
			lv.memory = conf['memory']
			lv.cpus = conf['cpus']
			lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => '1'
		end
		k.vm.provision 'shell', path: "provision/#{conf['provision']}", args: "#{conf['ip']}"
		end
	end

	config.vm.provision 'shell', path: 'provision/provision.sh'
end
