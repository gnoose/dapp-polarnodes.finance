// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

interface INodeType {

	function transferFrom(address from, address to, uint tokenId) external;
	function burnFrom(address from, uint[] memory tokenIds) external returns(uint);

	function createNodesWithTokens(
		address user,
		uint[] memory tokenIds
	) external returns(uint);

	function createNodesLevelUp(
		address user,
		uint[] memory tokenIds
	) external returns(uint);

	function createNodesWithPendings(
		address user,
		uint[] memory tokenIds
	) external returns(uint);
	
	function createNodeWithLuckyBox(
		address user,
		uint[] memory tokenIds,
		string memory feature
	) external;

	function createNodesMigration(
		address user,
		uint[] memory tokenIds
	) external;

	function createNodeCustom(
		address user,
		uint isBoostedAirDropRate,
		uint[] memory tokenIds,
		bool[] memory areBoostedNft,
		bool isBoostedToken,
		string memory feature
	) external;

	function getTotalNodesNumberOf(address user) external view returns(uint);
	function getAttribute(uint tokenId) external view returns(string memory);

	function claimRewardsAll(address user) external returns(uint, uint);
	function claimRewardsBatch(address user, uint[] memory tokenIds) external returns(uint, uint);
	function calculateUserRewards(address user) external view returns(uint, uint);

	function name() external view returns(string memory);
	function totalCreatedNodes() external view returns(uint);
}

