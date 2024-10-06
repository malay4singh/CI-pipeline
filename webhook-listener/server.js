const express = require('express');
const { exec } = require('child_process');
const server = express();


server.use(express.json());

server.post('/', (req, res) => {
	const { event, branch, repo } = req.body;

	const repository = repo.split('/')[1];

	if ( event == "push" ) {
		exec(`sh /home/hamster/scripts/${branch}.sh ${repository}`, (error, stdout, stderr) => {
			if (error) {
            			console.error(error.message);
            			return res.status(500).json({
                			status: 'failure',
                			message: error.message
            			});
        		}

        		console.log(`Script output: ${stdout}`);
        		return res.status(200).json({
            			status: 'success',
            			message: 'Script executed successfully'
			})
		})
	}	
})

server.listen(3000, () => {
	console.log("Server running on PORT 3000");
})
