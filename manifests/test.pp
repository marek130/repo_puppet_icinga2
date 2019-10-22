node "testovaci.stroj.cerit-sc.cz" {

  # NASTAVENIE MENA A HESLA K API
  class { "icinga2::api":
      users     => ["meno-api"],
      passowrds => ["api-heslo"],
      urls      => ["https://monitor.ics.muni.cz:5665"], # INSTANCIA ICINGY2
  }
  
  icinga2::icinga2_host { "testovaci.stroj.cerit-sc.cz":
    ensure               => "present",
    check_command        => "hostalive",
    address              => "127.0.0.1",
    templates            => ["generic-host"],
    enable_notifications => true,
  }

  $services = lookup('icinga2::services::nrpe')
  
  $services.each |$name| {
    icinga2::icinga2_service { "check_nrpe_${name}":
      check_command          => "nrpe",
      enable_notifications   => true,
      notification_users     => ["user.ics.muni.cz"],
      vars                   => { "nrpe_port" => 5666, "nrpe_command" => $name },
    } 
  }
}
