#!/bin/sh
# Basically copy fils from x86_64 and make changes as in https://github.com/yast/skelcd-control-openSUSE/blob/master/package/skelcd-control-openSUSE.spec
# TODO: handle Leap

additionnal_archs="aarch64 armv7hl armv6hl ppc"

for ports_arch in $additionnal_archs; do
	echo "Arch: $ports_arch"
	
	echo "  Generating openSUSE_"$ports_arch"_Factory_Servers.xml.in"
	cp openSUSE_Factory_Servers.xml.in openSUSE_$ports_arch\_Factory_Servers.xml.in
	sed -i -e "s,_openSUSE_Factory_Default.xml,_openSUSE_$ports_arch\_Factory_Default.xml," openSUSE_$ports_arch\_Factory_Servers.xml.in
	sed -i -e "s,openSUSE_Tumbleweed_Community_Additional.xml,openSUSE_$ports_arch\_Tumbleweed_Community_Additional.xml," openSUSE_$ports_arch\_Factory_Servers.xml.in
	
	file="_openSUSE_Factory_Default.xml.in"
	output_file="_openSUSE_"$ports_arch"_Factory_Default.xml.in"
	echo "  Generating $output_file"
	cp $file $output_file
	sed -i -e "s,http://download.opensuse.org/tumbleweed/,http://download.opensuse.org/ports/$ports_arch/tumbleweed/," $output_file
	sed -i -e "s,http://download.opensuse.org/debug/,http://download.opensuse.org/ports/$ports_arch/debug/," $output_file
	sed -i -e "s,http://download.opensuse.org/source/,http://download.opensuse.org/ports/$ports_arch/source/," $output_file
	sed -i -e "s,http://download.opensuse.org/update/tumbleweed/,http://download.opensuse.org/ports/$ports_arch/update/tumbleweed/," $output_file
	# Leap specific
	sed -i -e "s,http://download.opensuse.org/distribution/,http://download.opensuse.org/ports/$ports_arch/distribution/," $output_file
	sed -i -e "s,http://download.opensuse.org/update/leap/,http://download.opensuse.org/ports/update/leap/," $output_file
	sed -i -e "s,http://download.opensuse.org/debug/update,http://download.opensuse.org/ports/debug/update," $output_file
	
	echo "Please remove non-oss repo part manually from _openSUSE_"$ports_arch"_Factory_Default.xml.in (TODO: do it from script)"
done
