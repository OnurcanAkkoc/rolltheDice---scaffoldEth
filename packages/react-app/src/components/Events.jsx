import { List } from "antd";
import { useEventListener } from "eth-hooks/events/useEventListener";
import Address from "./Address";
import {ethers} from "ethers";
import { useEffect, useState } from "react";


/**
  ~ What it does? ~

  Displays a lists of events

  ~ How can I use? ~

  <Events
    contracts={readContracts}
    contractName="YourContract"
    eventName="SetPurpose"
    localProvider={localProvider}
    mainnetProvider={mainnetProvider}
    startBlock={1}
  />
**/

export default function Events({ contracts, contractName, eventName, localProvider, mainnetProvider, startBlock }) {
  // 📟 Listen for broadcast events
  const events = useEventListener(contracts, contractName, eventName, localProvider, startBlock);

  const [savedEvents, setSavedEvents] = useState([]);

  useEffect(() => {
    setSavedEvents(events.reverse())

  }, [events])
  return (
    <div style={{ width: 600, margin: "auto", marginTop: 32, paddingBottom: 32 }}>
      <h2>Events:</h2>
      <List
        bordered
        dataSource={savedEvents}
        renderItem={item => {
          return (
            <List.Item key={item.blockNumber + "_" + item.args.sender + "_" + item.args.purpose}>
              <Address address={item.args[0]} ensProvider={mainnetProvider} fontSize={16} />
              {item.args[1].toNumber()}
              <div style={{padding:10}} >{ethers.utils.formatEther(item.args[2])}</div>
            </List.Item>
          );
        }}
      />
    </div>
  );
}
