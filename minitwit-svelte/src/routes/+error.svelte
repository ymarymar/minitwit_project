<script>
    import { page } from '$app/state'; 
    import PageWrapper from '$lib/components/PageWrapper.svelte';
    import * as Card from "$lib/components/ui/card/index.js";
</script>

<PageWrapper>
    <Card.Root class="overflow-hidden p-0">
        <Card.Content class="p-0">
            <div class="flex justify-center flex-col gap-4 p-6 md:p-8">
                <h1 class="text-2xl font-bold">{page.status}</h1>
                <p class="text-gray-400 mb-6">{page.error?.message ?? 'Something went wrong'}</p>
            </div>
        </Card.Content>
    </Card.Root>
</PageWrapper>