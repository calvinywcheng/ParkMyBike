require 'test_helper'

class BikeRacksControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'parse invalid url' do
    assert_raises StandardError do
      @controller.send(:update_bike_racks, 'ftp://foobar.zzz')
    end

    assert_raises StandardError do
      @controller.send(:update_bike_racks,
                       'ftp://webftp.vancouver.ca/opendata/bike_rack/BikeRackData.com')
    end

    assert_raises do
      @controller.send(:update_bike_racks,
                       'ftp://webftp.vancouver.ca/opendata/bike_rack/BikeRackData.csv3')
    end
  end

  test 'parse valid url' do
    assert_nothing_raised do
      counter = @controller.send(:update_bike_racks,
                                 BikeRacksController::DEFAULT_URI)
      puts 'Results of parsing:'
      counter.each { |k, v| puts "#{k.to_s}: #{v}" }
      puts ''
      assert counter[:valid] >= 0
      assert counter[:invalid] >= 0
    end

    puts 'Flash messages:'
    flash.each { |k, v| puts "#{k.to_s}: #{v}" }
    puts ''
  end

  test 'missing data' do
    dataset = [
        {},
        {'St Number' => '1935', 'St Name' => 'Lower Mall', 'Street Side' => 'North'},
        {'St Number' => '1935', 'St Name' => 'Lower Mall', '# of racks' => 5},
        {'St Number' => '1935', '# of racks' => 5, 'Street Side' => 'North'},
        {'St Name' => 'Lower Mall', 'Street Side' => 'North', '# of racks' => 5}]
    dataset.each { |data| assert_not @controller.send(:store_one_bike_rack, data) }
  end

  test 'invalid data' do
    dataset = [
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'Right', '# of racks' => 3},
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'North', '# of racks' => 0},
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'South', '# of racks' => 'three'},
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'South', '# of racks' => 'Two'},]
    dataset.each { |data| assert_not @controller.send(:store_one_bike_rack, data) }
  end

  test 'duplicate data' do
    data = [
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'North', '# of racks' => 3},
        {'St Number' => '12', 'St Name' => 'Lower Mall', 'Street Side' => 'North', '# of racks' => 3},
        {'St Number' => '12', 'St Name' => 'Upper Mall', 'Street Side' => 'North', '# of racks' => 3}]
    assert @controller.send(:store_one_bike_rack, data[0])
    assert_not @controller.send(:store_one_bike_rack, data[1])
    assert @controller.send(:store_one_bike_rack, data[2])
  end

  test 'valid data' do
    dataset = [
        {'St Number' => '1935', 'St Name' => 'Lower Mall', 'Street Side' => 'North', '# of racks' => 4},
        {'St Number' => '5840', 'St Name' => 'Dover Cres', 'Street Side' => 'West', '# of racks' => 3},
        {'St Number' => '1234', 'St Name' => 'Foo St', 'Street Side' => 'East', '# of racks' => 2},
        {'St Number' => '9876', 'St Name' => 'Bar Ave', 'Street Side' => 'South', '# of racks' => 1}]
    dataset.each { |data| assert @controller.send(:store_one_bike_rack, data) }
  end
end
