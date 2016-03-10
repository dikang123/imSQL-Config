Name:       ParateraDB-Configuration
Version:    1.0.11
Release:	1%{?dist}
Summary:	ParateraDB Configuration Files.

Group:      Databases/ParateraDB	
License:    Copyright(c) 2015	
URL:	    https://git.paratera.net/dba/ParateraDB-Utils	
Source0:    https://git.paratera.net/dba/%{name}.tar.gz	


BuildRequires: coreutils grep procps shadow-utils time 

Requires:       grep coreutils procps shadow-utils time 
%description
    ParateraDB Configuration Files.

%prep
%setup -q -n %{name}


%install

RBR=$RPM_BUILD_ROOT
MBD=$RPM_BUILD_DIR/%{name}

install -D -m 0644 $MBD/my.cnf.sample $RBR/etc/my.cnf.sample
install -D -m 0644 $MBD/sysctl.conf.sample $RBR/etc/sysctl.conf.sample
install -D -m 0644 $MBD/limits.conf.sample $RBR/etc/security/limits.conf.sample
install -D -m 0755 $MBD/scripts/adaptive_parteradb.sh $RBR/%{_bindir}/adaptive_parteradb

%post 
%{_bindir}/adaptive_parteradb

%files
/etc/my.cnf.sample
/etc/sysctl.conf.sample
/etc/security/limits.conf.sample
%{_bindir}/adaptive_parteradb
#%doc

%changelog

