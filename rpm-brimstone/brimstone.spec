%global commit 37735e60b294574613ac70c8aeed650b4845c225
%global short_commit %(c=%{commit}; echo ${c:0:7})
%global commit_date 20180430

Name:           brimstone
Version:        5
Release:        0.1.%{commit_date}git%{short_commit}%{?dist}
Summary:        An automated rpm build and repository creation script based on mock

Group:          System Environment/Base
License:        GPLv3
URL:            https://github.com/dcrdev/%{name}
Source0:        https://github.com/dcrdev/%{name}/archive/%{short_commit}/%{name}-%{commit}.tar.gz
BuildArch:      noarch

Requires:       mock
Requires:       rsync
Requires:       createrepo

%description
%{summary}.

%prep
%setup -qn %{name}-%{commit}

%build
echo "Nothing to build"

%install
install -d -m755 \
  %{buildroot}%{_bindir}

%{__install} -p -m755 %{name} \
    %{buildroot}%{_bindir}

%files
%{_bindir}/%{name}

%changelog
* Mon Apr 30 2018 Dominic Robinson <github@dcrdev.com> - 5-0.1.20180430git37735e6
- Bump to version 5
* Sat Apr 28 2018 Dominic Robinson <github@dcrdev.com> - 4-0.1.20180428git96fa329
- Bump to version 4
* Sat Jun 10 2017 Dominic Robinson <github@dcrdev.com> - 3-0.2.20170601git47c0b18
- Add requires section
* Thu Jun 01 2017 Dominic Robinson <github@dcrdev.com> - 3-0.1.20170601git47c0b18
- Bump to version 3
* Thu Jun 01 2017 Dominic Robinson <github@dcrdev.com> - 2-0.1.20170601git1dc5054
- Bump to version 2
* Sat May 20 2017 Dominic Robinson <github@dcrdev.com> - 1-0.1.20170520gitc41b0ff
- Initial RPM Release

