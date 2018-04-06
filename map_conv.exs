# map_conv.exs

map_orig =
  %{
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

# パターンマッチで、マッチするものがなかった場合のデフォルト値は？
# なかったら MatchError になる

# 関数でやってみるか？

#%{"geometry" => geometry} = map_orig
%{"geometry" => %{"coordinates" => %{"Latitude" => lat, "Longitude" => lng}}} = map_orig
#%{"RunningStatus" => RunningStatus} = map_orig # こちらはNG
%{"RunningStatus" => runningStatus} = map_orig # こちらはOK。変数の先頭が大文字NGとかある？
%{"VehicleSpeed" => %{"Speed" => speed, "Timestamp" => _}} = runningStatus
%{"EngineSpeed" => %{"RPM" => rpm}} = runningStatus
%{"SteeringWheel" => %{"Angle" => steer}} = runningStatus
%{"AcceleratorPedalPosition" => %{"PedalPosition" => accelPedal}} = runningStatus
#%{"Fuel" => %{"InstantConsumption" => fuel }} = runningStatus
#%{"Fuel" => fuel} = runningStatus
fuel = get_instantConsumption(map_orig)

%{"Acceleration" => %{"X" => accX, "Y" => accY, "Z" => accZ}} = runningStatus

#%{"RunningStatus" => RunningStatus} = map_orig # こちらはNG
#IO.puts "map_orig = #{inspect(map_orig)}"


def get_instantConsumption(map_orig) do
  val = case map_orig do
    %{"RunningStatus" => runningStatus} ->
      case runningStatus do
        %{"Fuel" => fuel} ->
          case fuel do
            %{"InstantConsumption" => inst} -> inst
            _ -> :ok
          end
          _ -> :ok
      end
      _ -> :ok
  end
end


#IO.puts "geometry = #{inspect(geometry)}"
IO.puts "geometry = Lat= #{lat}, Lng = #{lng}"
#IO.puts "RunningStatus = #{inspect(RunningStatus)}"
#IO.puts "RunningStatus = #{inspect(runningStatus)}"
IO.puts "VehicleSpeed = #{inspect(speed)}"
IO.puts "EngineSpeed = #{inspect(rpm)}"
IO.puts "SteeringWheel = #{inspect(steer)}"
IO.puts "AccelPedal = #{inspect(accelPedal)}"
IO.puts "Fuel = #{inspect(fuel)}"
#IO.puts "Acceleration = #{inspect(accel)}"
IO.puts "Acceleration = #{accX}, #{accY}, #{accZ}"

map_out = %{"VehicleSpeed" => speed}

IO.puts "map_out = #{inspect(map_out)}"




