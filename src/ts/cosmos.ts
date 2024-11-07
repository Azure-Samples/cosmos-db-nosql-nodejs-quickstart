import { DefaultAzureCredential, TokenCredential } from '@azure/identity';
import { Container, CosmosClient, Database, FeedResponse, ItemResponse, SqlQuerySpec } from '@azure/cosmos';

import { Emit, Product } from './types'

export class DataClient {

    async start(emit: Emit) {
        const client: CosmosClient = await this.createClient(emit);

        emit('Current Status:\tStarting...');

        const container: Container = await this.createContainer(emit, client);

        await this.createItemVerbose(emit, container);

        await this.createItemConcise(emit, container);

        await this.readItem(emit, container);

        await this.queryItems(emit, container);

        emit('Current Status:\tFinalizing...');
    }

    async createClient(_: Emit): Promise<CosmosClient> {
        // <create_client>
        const endpoint: string = process.env.CONFIGURATION__AZURECOSMOSDB__ENDPOINT!
        console.log(`ENDPOINT: ${endpoint}`);

        const credential: TokenCredential = new DefaultAzureCredential();

        const client = new CosmosClient({
            endpoint,
            aadCredentials: credential
        });
        // </create_client>

        return client;
    }

    async createContainer(emit: Emit, client: CosmosClient): Promise<Container> {
        const databaseName: string = process.env.CONFIGURATION__AZURECOSMOSDB__DATABASENAME ?? 'cosmicworks';
        const database: Database = client.database(databaseName);

        emit(`Get database:\t${database.id}`);

        const containerName: string = process.env.CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME ?? 'products';
        const container: Container = database.container(containerName);

        emit(`Get container:\t${container.id}`);

        return container;
    }

    async createItemVerbose(emit: Emit, container: Container) {
        var item: Product = {
            'id': 'aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb',
            'category': 'gear-surf-surfboards',
            'name': 'Yamba Surfboard',
            'quantity': 12,
            'price': 850.00,
            'clearance': false
        };

        var response: ItemResponse<Product> = await container.items.upsert<Product>(item);

        if (response.statusCode == 200 || response.statusCode == 201) {
            emit(`Upserted item:\t${JSON.stringify(response.resource)}`);
        }
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);
    }

    async createItemConcise(emit: Emit, container: Container) {
        var item: Product = {
            'id': 'bbbbbbbb-1111-2222-3333-cccccccccccc',
            'category': 'gear-surf-surfboards',
            'name': 'Kiama Classic Surfboard',
            'quantity': 25,
            'price': 790.00,
            'clearance': true
        };

        var { resource } = await container.items.upsert<Product>(item);
        emit(`Upserted item:\t${JSON.stringify(resource)}`);
    }

    async readItem(emit: Emit, container: Container) {
        var id = 'aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb';
        var partitionKey = 'gear-surf-surfboards';

        var response: ItemResponse<Product> = await container.item(id, partitionKey).read<Product>();
        var read_item: Product = response.resource!;

        emit(`Read item id:\t${read_item?.id}`);
        emit(`Read item:\t${JSON.stringify(read_item)}`);
        emit(`Status code:\t${response.statusCode}`);
        emit(`Request charge:\t${response.requestCharge}`);
    }

    async queryItems(emit: Emit, container: Container) {
        const querySpec: SqlQuerySpec = {
            query: 'SELECT * FROM products p WHERE p.category = @category',
            parameters: [
                {
                    name: '@category',
                    value: 'gear-surf-surfboards'
                }
            ]
        };

        var response: FeedResponse<Product> = await container.items.query<Product>(querySpec).fetchAll();
        for (var item of response.resources) {
            emit(`Found item:\t${item.name}\t${item.id}`);
        }
        emit(`Request charge:\t${response.requestCharge}`);
    }
}
