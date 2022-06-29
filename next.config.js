/** @type {import('next').NextConfig} */
const nextConfig = {
	reactStrictMode: true,
	swcMinify: true,
	experimental: {
    	outputStandalone: true,
  	},
	serverRuntimeConfig: {
        API_URL: process.env.API_URL,
    },
	publicRuntimeConfig: {
        NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
    }
}

module.exports = nextConfig
