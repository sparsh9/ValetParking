class ValetParking
  require 'json'
  require 'csv'
  licensePlateNumber = nil
  carsize = nil

  $space = CSV.read("ParkingLot.csv")
  $space = $space.to_a
  puts $space[0][2]

  def initialize(choice)
    if choice == "1"
      admitTheCar()
    elsif choice == "2"
      exitTheCar()
    else
      puts("Wrong choice")
    end
  end

  def parkingSpace
    $space
  end


  def admitTheCar()
    result = checkParkingSpace()
    if result == "success"
      puts ("Input License Plate Number")
      licensePlateNumber = gets.chomp
      puts("Input Carsize")
      carsize = gets.chomp
      if carsize.downcase == "s"
        checkAndUpdateSmallSpace(licensePlateNumber, carsize)
      elsif carsize.downcase == "m"
        resullt = checkAndUpdateMediumSpace(licensePlateNumber, carsize)
        if result == "failed"
          rearrangeAndUpdateMediumSpace(licensePlateNumber, carsize)
          return "success"
        end
      elsif carsize.downcase == "l"
        checkAndUpdateLargeSpace(licensePlateNumber, carsize)
      end
    end
  end

  def exitTheCar()
    puts("Input Licence Plate Number")
    licensePlateNumber = gets.chomp
    (0..$space.count-1).each do |i|
      if ($space[i][1].downcase == licensePlateNumber.downcase)
        $space[i][1] = 0
        $space[i][2] = 0
        updateCsvFile($space)
        puts "Your car is out of parking"
        break
      end
    end
  end

  def checkParkingSpace()
    sum = 0
    (0..$space.count-1).each do |i|
      if $space[i][1] == '0'
        sum = sum + 1
      else
        sum = sum
      end
    end

    if sum > 0
      return "success"
    else
      puts "No space available"
    end
  end

  def checkAndUpdateSmallSpace(licensePlateNumber, carsize)
    (0..$space.count-1).each do |i|
      if $space[i][1] ==  '0'
        $space[i][1] = licensePlateNumber
        $space[i][2] = carsize
        updateCsvFile($space)
        puts "Your car is parked"
        return "success"
        break
      end
    end
  end

  def checkAndUpdateMediumSpace(licensePlateNumber, carsize)
    (0..$space.count-1).each do |i|

      if ($space[i][0].downcase =~ /m/ || $space[i][0].downcase =~ /l/) && $space[i][1] == '0' && $space[i][2] == '0'
        $space[i][1] = licensePlateNumber
        $space[i][2] = carsize
        updateCsvFile($space)
        puts "Your car is parked"
        return "success"
        break
      end
    end
    return "failed"
  end

  def  checkAndUpdateLargeSpace(licensePlateNumber, carsize)
    (0..$space.count-1).each do |i|
      if $space[i][0].downcase =~ /l/ && $space[i][1] == '0'
        $space[i][1] = licensePlateNumber
        updateCsvFile($space)
        puts "Your car is parked"
        return "success"
        break
      else
        rearrangeAndUpdateLargeSpace(licensePlateNumber, carsize)
        break
      end
    end
  end

  # def rearrangeAndUpdateSmallSpace(licensePlateNumber, carsize)
  #   (0..$space.count-1).each do |i|
  #     if $space[i][1] ==  '0'
  #       $space[i][1] = licensePlateNumber
  #       $space[i][2] = carsize
  #       updateCsvFile($space)
  #       puts "Your car is parked"
  #       return "success"
  #       break
  #     end
  #   end
  # end

  def rearrangeAndUpdateMediumSpace(licensePlateNumber, carsize)
    (0..$space.count-1).each do |i|
      if ($space[i][0].downcase =~ /m/ && $space[i][2] == 's')
        (0..$space.count-1).each do |j|
          if($space[j][0].downcase =~ /s/ && $space[j][1] == '0' && $space[j][2] == '0')
            $space[j][1] = $space[i][1]
            $space[j][2] = $space[i][2]
            $space[i][1] = licensePlateNumber
            $space[i][2] = carsize
            updateCsvFile($space)
            puts "Your car is parked"
            return "success"
            break
          end
        end
      end
    end
  end

  def rearrangeAndUpdateLargeSpace(licensePlateNumber, carsize)
    (0..$space.count-1).each do |i|
      if ($space[i][0].downcase =~ /l/ && $space[i][2] == 'm')
        result = checkAndUpdateMediumSpace($space[i][1], $space[i][2])
        if result == "success"
          $space[i][1] = licensePlateNumber
          $space[i][2] = carsize
          updateCsvFile($space)
          break
        end
      elsif ($space[i][0].downcase =~ /l/ && $space[i][2].downcase == 's')
        result = checkAndUpdateSmallSpace($space[i][1], $space[i][2])
        if result == "success"
          $space[i][1] = licensePlateNumber
          $space[i][2] = carsize
           updateCsvFile($space)
          break
        end
        break
      else
        puts "No space available"
        break
      end
    end
  end


  def updateCsvFile(space)
    CSV.open 'ParkingLot.csv', 'wb' do |csv|
      (0..space.count-1).each do |i|
        csv << space[i]
      end
    end
  end

end

puts ("Enter 1 to Park")
puts ("Enter 2 to Take out")
choice = gets.chomp
valet = ValetParking.new(choice)


