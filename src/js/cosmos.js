import { DefaultAzureCredential } from '@azure/identity';
import { CosmosClient } from '@azure/cosmos';

export async function start(emit) {
    // <create_client>
    const endpoint = process.env.CONFIGURATION__AZURECOSMOSDB__ENDPOINT;
    console.log(`ENDPOINT: ${endpoint}`);

    const credential = new DefaultAzureCredential();

    const client = new CosmosClient({
        endpoint,
        aadCredentials: credential
    });
    // </create_client>
    emit('Current Status:\tStarting...');

    const databaseName = process.env.CONFIGURATION__AZURECOSMOSDB__DATABASENAME ?? 'cosmicworks';
    const database = client.database(databaseName);

    emit(`Get database:\t${database.id}`);

    const containerName = process.env.CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME ?? 'products';
    const container = database.container(containerName);

    emit(`Get container:\t${container.id}`);

    {
        var item = {
            'id': 'aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb',
            'category': 'gear-surf-surfboards',
            'name': 'Yamba Surfboard',
            'quantity': 12,
            'price': 850.00,
            'clearance': false
        };

        var response = await container.items.upsert(item);

        if (response.statusCode == 200 || response.statusCode == 201) {
            emit(`Upserted item:\t${JSON.stringify(response.resource)}`);
        }
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);        
    }

    {
        var item = {
            'id': 'bbbbbbbb-1111-2222-3333-cccccccccccc',
            'category': 'gear-surf-surfboards',
            'name': 'Kiama Classic Surfboard',
            'quantity': 25,
            'price': 790.00,
            'clearance': true
        };

        var { resource } = await container.items.upsert(item);
        emit(`Upserted item:\t${JSON.stringify(resource)}`);
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);  
    }

    {
        var id = 'aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb';
        var partitionKey = 'gear-surf-surfboards';

        var response = await container.item(id, partitionKey).read();
        var read_item = response.resource;

        emit(`Read item id:\t${read_item.id}`);
        emit(`Read item:\t${JSON.stringify(read_item)}`);
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);
    }

	{
        const querySpec = {
            query: 'SELECT * FROM products p WHERE p.category = @category',
            parameters: [
                {
                    name: '@category',
                    value: 'gear-surf-surfboards'
                }
            ]
        };
        
        var response = await container.items.query(querySpec).fetchAll();
        for (var item of response.resources) {
            emit(`Found item:\t${item.name}\t${item.id}`);
        }
        emit(`Request charge:\t${response.requestCharge}`);
    }

    emit('Current Status:\tFinalizing...');
}