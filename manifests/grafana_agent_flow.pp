include grafana_agent_module::grafana_agent_flow

class grafana_agent_module::grafana_agent_flow () {
  case $::os['family'] {
    'debian': {
      apt::source { 'grafana':
        location => 'https://apt.grafana.com/',
        release  => '',
        repos    => 'stable main',
        key      => {
          id     => 'B53AE77BADB630A683046005963FA27710458545',
          source => 'https://apt.grafana.com/gpg.key',
        },
      } -> package { 'grafana-agent-flow':
        require => Exec['apt_update'],
      } -> service { 'grafana-agent-flow':
        ensure    => running,
        name      => 'grafana-agent-flow',
        enable    => true,
        subscribe => Package['grafana-agent-flow'],
      }
    }
    'redhat': {
      yumrepo { 'grafana':
        ensure   => 'present',
        name     => 'grafana',
        descr    => 'grafana',
        baseurl  => 'https://packages.grafana.com/oss/rpm',
        gpgkey   => 'https://packages.grafana.com/gpg.key',
        enabled  => '1',
        gpgcheck => '1',
        target   => '/etc/yum.repo.d/grafana.repo',
      } -> package { 'grafana-agent-flow':
      } -> service { 'grafana-agent-flow':
        ensure    => running,
        name      => 'grafana-agent-flow',
        enable    => true,
        subscribe => Package['grafana-agent-flow'],
      }
    }
    default: {
      fail("Unsupported OS family: (${$::os['family']})")
    }
  }
}
