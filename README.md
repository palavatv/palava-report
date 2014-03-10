# palava report

## What is this?

This is a web app collecting information about working and non-working palava
sessions. It tries to help maintaining interoperability and identify browsers
and/or operating systems combinations which are not working.

Reports are collected about direct connections (PeerConnections) between two
participants. Multiple reports can be created for rooms with more than two
participants.

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

## Report Workflow

Reports are (hopefully) generated in a two step process. In the first step one
of the participants creates the report. This is done with an Ajax call to
`/create_report.json` POSTing the following data (for more information about
the values see above):

	portal_revision: hash
	client_revision: hash
	network_type: string
	known_to_work: true | false
	user_agent: navigator.userAgent
	quality: 0-10
	errors: one or multiple error strings
	comment: string

The server will respond with a JSON object containing an `id` which should be
transmitted to the client on the other side of the connection the report is
about. This client should then POST the following data to `/extend_report.json`:

	id: id of the report created by the other client
	user_agent: navigator.userAgent
	quality: 0-10
	errors: one or multiple error strings
	comment: string

There might be reports which are not extended by the second client. The user
should be encouraged to transmit the information because only reports with data
about both sides are really valuable.

