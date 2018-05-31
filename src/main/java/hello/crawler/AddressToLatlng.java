package hello.crawler;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import hello.model.MyAddress;

public class AddressToLatlng {
	
	public static MyAddress address2coordinate(String address) {
		if(address.equals("") || address == null) return null;
		MyAddress myAddress = null;
		String street = null, district = null, city = null;
		String lat, lng;
		
		address = address.replaceAll(" ", "%20");
		String link = "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyBtvz3YOKjqxV3bolU5uY0UDruVfFNguS8";
		//System.out.println(link);
		String data = "";
		URL url;
		
		try {
			url = new URL(link);
			InputStream inputStream = url.openConnection().getInputStream();
			StringBuilder builder = new StringBuilder();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					inputStream));

			String line;
			while ((line = reader.readLine()) != null) {
				builder.append(line + "\n");
			}
			data = builder.toString();
			//System.out.println(data);
			JSONObject jsonData = new JSONObject(data);
			JSONArray results = jsonData.getJSONArray("results");	//trong kq trả về thì results là key có value là 1 mảng
			//System.out.println(results);
			//thường thì mỗi địa chỉ sẽ chỉ có 1 kq, nên
			//jsonArray.length = 1. Nhưng cũng có trường hợp nhiều hơn 1,
			//VD: address = số 1 Đại Cồ Việt (trả về 2 kq)
			//Tạm thời chỉ lấy kq đầu tiên
			//System.out.println("length = " + results.length());
			JSONObject firstResult = results.getJSONObject(0);
			
			JSONArray address_components = firstResult.getJSONArray("address_components");
			JSONArray types;
			for(int i=0; i<address_components.length(); i++) {
				types = address_components.getJSONObject(i).getJSONArray("types");

				if(types.get(0).toString().equals("street_number") || types.get(0).toString().equals("premise")) {
					//Nếu address = "số 1 Đại Cồ Việt" thì nó ra kq là premise
					street = address_components.getJSONObject(i).getString("long_name");
				} else if(types.get(0).toString().equals("route")) {
					street += (" " + address_components.getJSONObject(i).getString("long_name"));
				} else if(types.get(0).toString().equals("administrative_area_level_2")) {
					district = address_components.getJSONObject(i).getString("long_name");
				} else if(types.get(0).toString().equals("administrative_area_level_1")) {
					city = address_components.getJSONObject(i).getString("long_name");
				}
			}
			
			JSONObject location = firstResult.getJSONObject("geometry").getJSONObject("location");
			lat = location.getDouble("lat") + "";
			lng = location.getDouble("lng") + "";

			myAddress = new MyAddress(lat, lng, street, district, city);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return myAddress;
	}

	public static void main(String[] args) {
		//MyAddress myAddress = AddressToLatlng.address2coordinate("số 1 Đại Cồ Việt");
		//MyAddress myAddress = AddressToLatlng.address2coordinate("số 10 chùa bộc");
		MyAddress myAddress = AddressToLatlng.address2coordinate("4 Tô Tịch, 100000, Hà Nội, Việt Nam");
		System.out.println(myAddress);
	}
}
