# palava report

## What is this?

This is a web app collecting information about working and non-working palava
sessions. It tries to help maintaining interoperability and identify browsers
and/or operating systems combinations which are not working.

## Data Structure

Each report represent a failed or successfull connection between two palava
clients. It contains information about the palava software version, the
software on the client side and the connection quality.

	time: timestamp

	portal-revision: "git revision"
	client-revision: "git revision"

	connection:
		type: "local" | "internet" | "mobile"
		known-to-work: true | false

	clients:
		[
			browser:
				name: "string"
				major: "major version"
				version: "string"

			os:
				name: "string"
				major: "major version"
				version: "string"

			device: "string"

			quality: 0-10 (0 is not working)

			errors:
				[
					"video" | "audio" | "peerconnection" | "no access request" | "design" | "other" | ..
				]

			comments: "string"
		]

Information about browsers, operating systems and device type is parsed using
[ua-parser](https://github.com/tobie/ua-parser).

