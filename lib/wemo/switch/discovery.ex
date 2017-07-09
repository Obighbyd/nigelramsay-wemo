defmodule Wemo.Switch.Discovery do
  import SweetXml
  alias Nerves.SSDPClient

  def all do
    SSDPClient.discover(target: "urn:Belkin:device:controllee:1")
    |> Enum.map(&extract_device_metadata_url/1)
    |> Enum.map(&query_device_metadata/1)
    |> Enum.map(&extract_metadata/1)
  end

  def extract_device_metadata_url({_, %{location: location}}) do
    location
  end

  def query_device_metadata(url) do
    %{status_code: 200, body: body} = response = HTTPotion.get(url)
    body
  end

  def extract_metadata(xml) do
    %Wemo.Switch.Metadata{
      device_type: xpath(xml, ~x"//root/device/deviceType/text()"),
      friendly_name: xpath(xml, ~x"//root/device/friendlyName/text()"),
      manufacturer: xpath(xml, ~x"//root/device/manufacturer/text()"),
      manufacturer_url: xpath(xml, ~x"//root/device/manufacturerURL/text()"),
      model_description: xpath(xml, ~x"//root/device/modelDescription/text()"),
      model_name: xpath(xml, ~x"//root/device/modelName/text()"),
      model_number: xpath(xml, ~x"//root/device/modelNumber/text()"),
      model_url: xpath(xml, ~x"//root/device/modelURL/text()"),
      serial_number: xpath(xml, ~x"//root/device/serialNumber/text()"),
      udn: xpath(xml, ~x"//root/device/UDN/text()"),
      upc: xpath(xml, ~x"//root/device/UPC/text()")
    }
  end
end
