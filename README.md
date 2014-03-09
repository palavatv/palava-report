# palava report

## What is this?

This is a web app collecting information about working and non-working palava
sessions. It tries to help maintaining interoperability and identify browsers
and/or operating systems combinations which are not working.

## Data Structure

Reports are organized as connections which represent a failed or successfull
connection between two palava clients. It contains information about the palava
software version, the software on the client side and the connection quality.

	id: "uuid"

	portal-revision: "git revision"
	client-revision: "git revision"

	connection:
		type: "local" | "internet" | "mobile"
		known-to-work: true | false

	clients:
		[
			id: "uuid"

			browser:
				name: "string"
				major: major version int
				version: "string"

			os:
				name: "string"
				major: major version int
				version: "string"

			device: "string"

			quality: 0-10 (0 is not working)

			errors:
				[
					"video" | "audio" | "peerconnection" | "no access question" | "design bug" | "other" | ..
				]

			comments: "string"
		]

