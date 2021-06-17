module BadJoke
  def self.tell_a_new_joke
    puts "\n"
    value = Kernel.system 'curl -H "Accept: text/plain" https://icanhazdadjoke.com/'
    puts "\n"
  end
end
