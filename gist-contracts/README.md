## Smart Contracts

- DeepVerseDigitalTwin.sol

The contract creates ERC721 standard NFTs, which currently takes the name and url/ipfs location of the file. It was empowered to call oracles to feed its charaters such as labels and the associated accuracies based on machine learning algorithms. The commercial machine learning model API and the external adaptor is available under this repo at 'external-adaptor'. Our machine learning algorithms was made available in a seperate python script, which we have not been able to host it online as a free API call, but the logic and structure will be the same as the external adaptor shows. The features and capabilities were demonstrated in the video.

Deployed contract at Kovan:  0x66D5C505129D5f9C79d42aDbF3Aae168F6D257E7
which you can call the function `requestNewDigitalTwin` and pass the `'seed', 'name', 'image_url'`, e.g.
"2","fox","https://ipfs.rarible.com/ipfs/QmdvztfxnwhnN9yFDHBwusFDUDTzvt4SP9pp4RjVgxCmyw/image.jpeg"
and you will be issued with an ERC721 token with additional features associated with the token such as labels and accuracy, which is currently represented via two uint256 numbers.


- APIData.sol

This is a general contract fetch information from any API using HTTP GET. In this specific case, wolfram alpha is used to return dummy results. Users shall change the API key or APPID and return results accordingly.


