class ValetParking
  require 'json'
  require 'csv'
  licensePlateNumber = nil
  carsize = nil

  $space = CSV.read("ParkingLot.csv")
  $space = $space.to_a

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
    puts "here"
    result = checkParkingSpace()
    if result == "success"
      puts ("Input License Plate Number")
      licensePlateNumber = gets.chomp
      puts("Input Carsize")
      carsize = gets.chomp
      if carsize.downcase == "s"
        checkAndUpdateSmallSpace(licensePlateNumber)
      elsif carsize.downcase == "m"
        checkAndUpdateMediumSpace(licensePlateNumber)
      elsif carsize.downcase == "l"
        checkAndUpdateLargeSpace(licensePlateNumber)
      end
    end
  end

  def exitTheCar()
    puts("Input Licence Plate Number")
    licensePlateNumber = gets.chomp
    (0..$space.count-1).each do |i|
      if ($space[i][1].downcase == licensePlateNumber.downcase)
        $space[i][1] = 0
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

  def checkAndUpdateSmallSpace(licensePlateNumber)
    (0..$space.count-1).each do |i|
      if $space[i][1] ==  '0'
        $space[i][1] = licensePlateNumber
        updateCsvFile($space)
        puts "Your car is parked"
        break
      end
    end
  end

  def checkAndUpdateMediumSpace(licensePlateNumber)
    (0..$space.count-1).each do |i|
      if ($space[i][0] =~ /m/ || $space[i][0] =~ /l/) && $space[i][1] == '0'
        $space[i][1] = licensePlateNumber
        updateCsvFile($space)
        puts "Your car is parked"
        break
      end
    end
  end

  def  checkAndUpdateLargeSpace(licensePlateNumber)
    (0..$space.count-1).each do |i|
      if $space[i][0] =~ /l/ && $space[i][1] == '0'
        $space[i][1] = licensePlateNumber
        updateCsvFile($space)
        puts "Your car is parked"
        break
      else

      end
    end
  end

  def updateCsvFile(space)
    CSV.open 'ParkingLot.csv', 'wb' do |csv|
      (0..space.count-1).each do |array|
        csv << space[array]
      end
    end
  end

end

puts ("Enter 1 to Park")
puts ("Enter 2 to Take out")
choice = gets.chomp
valet = ValetParking.new(choice)


