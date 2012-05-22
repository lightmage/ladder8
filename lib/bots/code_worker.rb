require 'date'
require 'timeout'
require 'weskit/lobby'

class CodeWorker < Weskit::Lobby::Bot
  def initialize nick, code
    super random_name, :version => Ladder8::Application.config.wesnoth_version
    @nick, @code = nick.strip.to_s, code.to_s
  end

  def send_code
    return [false, "Invalid nick was given"] unless @nick =~ Player::VALID_NICK
    return [false, "Specified user is already registered on ladder"] if Player.find_by_nick_parameterized @nick

    months_limit = 3

    begin
      Timeout.timeout(9) do
        connect_and do
          lobby_info = read_wml
          server_msg = read_wml

          user = lobby_info.user.find {|u| u[:name] == @nick}

          raise_error "Specified user is not logged on 'server.wesnoth.org'" unless user
          raise_error "Specified user is not registered on official fourms"  unless user[:registered]
          
          send_info_query
          while wml = read_wml do
            if is_server_message? wml
              message    = wml.message[:message]
              registered = get_registration_time message

              #unless months_limit.months.ago > registered
              #  raise_error "Specified user didn't registered on forums in last #{months_limit} months"
              #end

              send_reg_code
              break
            end
          end
        end
      end
    rescue Timeout::Error
      return [false, "The operation has timed-out, please try again later"]
    rescue Weskit::Lobby::BotError => e
      return [false, e.message]
    rescue
      return [false, "Problem during connection to the server, if you didn't recieved registration code please try again later"]
    end

    [true, "Registration code deliverd succesfully"]
  end

  private

  def get_registration_time message
    DateTime.parse(message.each_line.detect {|line| line.include? 'Registered: '})
  end

  def is_server_message? wml
    !wml.message.empty? and wml.message[:sender] == 'server'
  end

  def raise_error message
    raise Weskit::Lobby::BotError, message
  end

  def random_name
    f = %w(Gutless Reckless Retarded Silly Unlucky)
    s = %w(AI Bat Dwarf Grunt Lord)

    f.shuffle.first + s.shuffle.first + "#{rand(900) + 100}"
  end

  def send_reg_code
    send_wml 'whisper', :message => "registration code: #{@code}", :receiver => @nick
  end

  def send_info_query
    send_wml 'nickserv', :info => {:name => @nick}
  end
end
