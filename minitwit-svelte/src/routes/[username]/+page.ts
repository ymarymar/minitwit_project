import type { Message } from '$lib/types';
import type { PageLoad } from './$types';
import { error } from '@sveltejs/kit';

export const load: PageLoad = async ({ fetch, params, url }) => {
    const page = Number(url.searchParams.get('page') ?? 0);

    const response = await fetch(`/web/user/${params.username}?page=${page}`);

    if (response.status === 404) {
        throw error(404, `User "${params.username}" not found`);
    }

    if (!response.ok) {
        throw error(response.status, 'Something went wrong');
    }

    const result = await response.json();

    return {
        messages: result.messages as Message[],
        following: result.following as boolean,
        total: result.total as number,
        page
    };
};
