set call_by_web to false
on open location this_URL
	set call_by_web to true
	#display alert "will open the url:" & this_URL
	return do shell script "/Applications/RustDesk.app/Contents/MacOS/rustdesk --play '" & this_URL & "'"
	#return do shell script "open -b 'com.carriez.rustdesk' --args --play" & space & quoted form of this_URL
end open location
#display alert "register RustDesk successfully."
#set my_URL to "rustdesk://meshinfo/desk?id=1277363449&password=8n6tyn"
#do shell script "/Users/macpro/workspace/lizpcarl/rustdesk/target/release/bundle/osx/RustDesk.app/Contents/MacOS/rustdesk --play '" & my_URL & "'"
if call_by_web is false then
	return do shell script "/Applications/RustDesk.app/Contents/MacOS/rustdesk"
end if