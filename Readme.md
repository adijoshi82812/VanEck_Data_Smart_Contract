<h1>VanEck Data Integration</h1>

<h2>Steps For Using This Oracle</h2>
<ul>
    <li>Write and deploy your Chainlink Contract</li>
    <li>Fund it with LINK</li>
    <li>Call your request method</li>
</ul>

<h2>Network Details</h2>
<h3>Ethereum Goerli Testnet</h3>
Payment amount: 0.1 LINK<br />
LINK Token address: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB<br />
Oracle Address: 0xbC364586b1699E89dB763bC328cB7E486eFFB21e<br />
JobID: 323d160b7ba842178526ced8bf7e7ba6

<h2>Request Parameters</h2>

`Ticker`
<ul>
    <li>Ticker: Description</li>
</ul>

<h3>Solidity Example</h3>

`req.add("id", <place_the_id_to_retrieve_data_of>);` <br />
`req.add("path", "data,Ticker");`

More Details

`ISIN`
<ul>
    <li>ISIN: Description</li>
</ul>

<h3>Solidity Example</h3>

`req.add("id", <place_the_id_to_retrieve_data_of>);` <br />
`req.add("path", "data,ISIN");`

More Details

`Holding Name`
<ul>
    <li>Holding Name: Description</li>
</ul>

<h3>Solidity Example</h3>

`req.add("id", <place_the_id_to_retrieve_data_of>);` <br />
`req.add("path", "data,Holding Name");`

More Details

`Shares`
<ul>
    <li>Shares: Description</li>
</ul>

<h3>Solidity Example</h3>

`req.add("id", <place_the_id_to_retrieve_data_of>);` <br />
`req.add("path", "data,Shares");`

More Details