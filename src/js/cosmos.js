import { DefaultAzureCredential } from '@azure/identity';
import { CosmosClient } from '@azure/cosmos';

export async function start(emit) {
    const endpoint = process.env.AZURE_COSMOS_DB_NOSQL_ENDPOINT;
    console.log(`ENDPOINT: ${endpoint}`);

    // <create_client>
    const credential = new DefaultAzureCredential();

    const client = new CosmosClient({
        endpoint,
        aadCredentials: credential
    });
    // </create_client>
    emit('Current Status:\tStarting...')

    // <get_database>
    const database = client.database('cosmicworks');
    // </get_database>
    emit(`Get database:\t${database.id}`);

    // <get_container>
    const container = database.container('products');
    // </get_container>
    emit(`Get container:\t${container.id}`);

    {
        // <create_item>
        var item = {
            'id': '70b63682-b93a-4c77-aad2-65501347265f',
            'category': 'gear-surf-surfboards',
            'name': 'Yamba Surfboard',
            'quantity': 12,
            'price': 850.00,
            'clearance': false
        };

        var response = await container.items.upsert(item);
        // </create_item>
        if (response.statusCode == 200 || response.statusCode == 201) {
            emit(`Upserted item:\t${JSON.stringify(response.resource)}`);
        }
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);        
    }

    {
        var item = {
            'id': '25a68543-b90c-439d-8332-7ef41e06a0e0',
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
		// <read_item>
        var id = '70b63682-b93a-4c77-aad2-65501347265f';
        var partitionKey = 'gear-surf-surfboards';

        var response = await container.item(id, partitionKey).read();
        var read_item = response.resource;
		// </read_item>
        emit(`Read item id:\t${read_item.id}`);
        emit(`Read item:\t${JSON.stringify(read_item)}`);
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);
    }

	{
		// <query_items>
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

        }
		// </query_items>
        for (var item of response.resources) {
            emit(`Found item:\t${item.name}\t${item.id}`);
        }
        emit(`Request charge:\t${response.requestCharge}`);
    }
}