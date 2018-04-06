# map_conv.exs
defmodule MapConv do

  def map_to_runStat(map) do
    val = case map do
      %{"RunningStatus" => runStat} -> runStat
      _ -> nil
    end
    val
  end
  def map_to_coord(map) do
    val = case map do
      %{"geometry" => geometry} ->
        case geometry do
          %{"coordinates" => coord} -> coord
          _ -> nil
        end
      _ -> nil
    end
    val
  end

  # RunningStatusから Fuel.instantConsumption取り出す
  # VehicleSpeed
  def runStat_to_VehicleSpeed(runStat) do
    val = case runStat do
      %{"VehicleSpeed" => vehicleSpeed} ->
        case vehicleSpeed do
          %{"Speed" => speed} -> speed
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # timestamp
  def runStat_to_timestamp(runStat) do
    val = case runStat do
      %{"VehicleSpeed" => vehicleSpeed} ->
        case vehicleSpeed do
          %{"Timestamp" => time} -> time
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # EngineSpeed
  def runStat_to_EngineSpeed(runStat) do
    val = case runStat do
      %{"EngineSpeed" => engineSpeed} ->
        case engineSpeed do
          %{"RPM" => rpm} -> rpm
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # SteeringWheel
  def runStat_to_SteeringWheel(runStat) do
    val = case runStat do
      %{"SteeringWheel" => steer} ->
        case steer do
          %{"Angle" => angle} -> angle
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # AccelPedalPosition
  def runStat_to_AcceleratorPedalPosition(runStat) do
    val = case runStat do
      %{"AcceleratorPedalPosition" => steer} ->
        case steer do
          %{"PedalPosition" => pedal} -> pedal
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # Fuel
  def runStat_to_InstantConsumption(runStat) do
    val = case runStat do
      %{"Fuel" => fuel} ->
        case fuel do
          %{"InstantConsumption" => inst} -> inst
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # Acceleratiion/X/Y/Z
  def runStat_to_AccelerationX(runStat) do
    val = case runStat do
      %{"Acceleration" => accel} ->
        case accel do
          %{"X" => x} -> x
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  def runStat_to_AccelerationY(runStat) do
    val = case runStat do
      %{"Acceleration" => accel} ->
        case accel do
          %{"Y" => y} -> y
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  def runStat_to_AccelerationZ(runStat) do
    val = case runStat do
      %{"Acceleration" => accel} ->
        case accel do
          %{"Z" => z} -> z
          _ -> nil # no instConsm
        end
      _ -> nil # no Fuel
    end
    val
  end
  # geometry/Lat/Lng
  def coord_to_Latitude(coord) do
    val = case coord do
      %{"Latitude" => lat} -> lat
      _ -> nil # no Fuel
    end
    val
  end
  def coord_to_Longitude(coord) do
    val = case coord do
      %{"Longitude" => lng} -> lng
      _ -> nil # no Fuel
    end
    val
  end
  # FullConvert
  def conv_ivis_to_fleetdev(map_orig) do

    runStat = MapConv.map_to_runStat(map_orig)
    coord = MapConv.map_to_coord(map_orig)

    vspeed = MapConv.runStat_to_VehicleSpeed(runStat)
    time = MapConv.runStat_to_timestamp(runStat)

    #IO.puts "vehicleSpeed = #{inspect(vspeed)}"
    espeed = MapConv.runStat_to_EngineSpeed(runStat)
    steer  = MapConv.runStat_to_SteeringWheel(runStat)
    apedal = MapConv.runStat_to_AcceleratorPedalPosition(runStat)
    fuel   = MapConv.runStat_to_InstantConsumption(runStat)
    #IO.puts "Fuel = #{inspect(fuel)}"

    accX = MapConv.runStat_to_AccelerationX(runStat)
    accY = MapConv.runStat_to_AccelerationY(runStat)
    accZ = MapConv.runStat_to_AccelerationZ(runStat)
    map_acc = %{ "x" => accX, "y" => accY, "z" => accZ}

    lat = MapConv.coord_to_Latitude(coord)
    lng = MapConv.coord_to_Longitude(coord)
    list_geo = [ lng, lat ]
    map_coord = %{ "coordinates" => list_geo}

    map_vehicle = Map.put(%{}, "engineSpeed", espeed)
               |> Map.put( "steeringWheel", steer)
               |> Map.put( "acceleratorPedalPosition", apedal)
               |> Map.put( "fuelInstantConsumption", fuel)
               |> Map.put( "acceleration", map_acc)

    map_out = Map.put(%{}, "geometry", map_coord)
               |> Map.put( "speed", vspeed)
               |> Map.put( "timestamp", time)
               |> Map.put( "vehicle", map_vehicle)
               |> Map.put( "userId", "user_id")
               |> Map.put( "moverType", "mover")
               |> Map.put( "moverId", "device_xxxx")
               |> Map.put( "eventType", "event_type")

    map_out
  end

end

# ====================
# IVIS Format
# ====================
map_orig = %{
  "geometry"=> %{
    "coordinates"=> %{
      "Latitude"=> "36.74024",
      "Longitude"=> "139.50351833333335",
      "Timestamp"=> "1515049619502"
    }
  },
  "RunningStatus"=> %{
    "VehicleSpeed"=> %{
      "Speed"=> "3010",
      "Timestamp"=> "1515049619502"
    },

    "EngineSpeed" => %{
      "RPM"=> "0",
      "tIMEstamp"=> "1515049619502"
    },
    "SteeringWheel"=> %{
      "Angle"=> "-440",
      "Timestamp"=> "1515049619502"
    },
    "AcceleratorPedalPosition"=> %{
      "PedalPosition"=> "0",
      "Timestamp"=> "1515049619502"
    },
    "Fuel"=> %{
      "Timestamp"=> "1515049619502"
    },
    "Acceleration"=> %{
      "X"=> "-0.003",
      "Y"=> "-0.06",
      "Z"=> "0.981",
      "Timestamp"=> "1515049619502"
    }
  }
}


#runStat = MapConv.map_to_runStat(map_orig)
#coord = MapConv.map_to_coord(map_orig)
#
#vspeed = MapConv.runStat_to_VehicleSpeed(runStat)
#time = MapConv.runStat_to_timestamp(runStat)
#
##IO.puts "vehicleSpeed = #{inspect(vspeed)}"
#espeed = MapConv.runStat_to_EngineSpeed(runStat)
#steer  = MapConv.runStat_to_SteeringWheel(runStat)
#apedal = MapConv.runStat_to_AcceleratorPedalPosition(runStat)
#fuel   = MapConv.runStat_to_InstantConsumption(runStat)
##IO.puts "Fuel = #{inspect(fuel)}"
#
#accX = MapConv.runStat_to_AccelerationX(runStat)
#accY = MapConv.runStat_to_AccelerationY(runStat)
#accZ = MapConv.runStat_to_AccelerationZ(runStat)
#map_acc = %{ "x" => accX, "y" => accY, "z" => accZ}
#
#lat = MapConv.coord_to_Latitude(coord)
#lng = MapConv.coord_to_Longitude(coord)
#list_geo = [ lng, lat ]
#map_coord = %{ "coordinates" => list_geo}



#map_out = %{}
#map_vehicle = Map.put(map_out, "engineSpeed", espeed)
#           |> Map.put( "steeringWheel", steer)
#           |> Map.put( "acceleratorPedalPosition", apedal)
#           |> Map.put( "fuelInstantConsumption", fuel)
#           |> Map.put( "acceleration", map_acc)
#
#map_out2 = Map.put(map_out, "geometry", map_coord)
#           |> Map.put( "speed", vspeed)
#           |> Map.put( "timestamp", time)
#           |> Map.put( "vehicle", map_vehicle)
#           |> Map.put( "userId", "user_id")
#           |> Map.put( "moverType", "mover")
#           |> Map.put( "moverId", "device_xxxx")
#           |> Map.put( "eventType", "event_type")
#

map_out = MapConv.conv_ivis_to_fleetdev(map_orig)

IO.puts "map_out = #{inspect(map_out)}"



# ==================
# Fleet_Device 形式に組み立てる
# ==================
#{
#  "geometry": {
#    "coordinates": [
#      139.50377666666665,
#      36.74055
#    ]
#  },
#  "timestamp": 1515049631649,
#  "speed": "33730",
#
#  "vehicle": {
#    "engineSpeed": "2355",
#    "steeringWheel": "0",
#    "acceleratorPedalPosition": "29",
#    "fuelInstantConsumption": "1478",
#    "acceleration": {
#      "z": "1.2",
#      "y": "-0.009",
#      "x": "0.002"
#    }
#  },
#
#  "userId": "user_id",
#  "moverType": "mover",
#  "moverId": "device_xxxx",
#  "eventType": "event_type"
#}


