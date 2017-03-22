service "ssh" do
  start_command "/etc/init.d/ssh start"
  stop_command "/etc/init.d/ssh stop"
  restart_command "/etc/init.d/ssh restart"
  status_command "/etc/init.d/ssh status"
  action [:start]
end
