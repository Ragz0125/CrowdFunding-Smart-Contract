// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract CrowdFundingContract {
    struct CampaignDetails {
        uint256 id;
        string campaignName;
        string description;
        uint256 goalAmount;
        uint256 collectedAmount;
        string endDate;
        string category;
        address payable receiverAddress;
        address creator;
    }

    mapping(address => CampaignDetails[]) public userCampaigns;

    CampaignDetails[] public campaignLists;

    uint256 campaignCounter;

    function publishCampaignDetails(
        string memory _campaignName,
        string memory _description,
        uint256 _goalAmount,
        string memory _endDate,
        string memory _category,
        address payable _receiverAddress
    ) public {
        require(_goalAmount > 0, "Goal Amount should be greater than 0");

        CampaignDetails memory _campaign = CampaignDetails({
            id: campaignCounter,
            campaignName: _campaignName,
            description: _description,
            goalAmount: _goalAmount,
            collectedAmount: 0,
            endDate: _endDate,
            category: _category,
            receiverAddress: _receiverAddress,
            creator: msg.sender
        });

        userCampaigns[msg.sender].push(_campaign);
        campaignLists.push(_campaign);

        campaignCounter++;
    }

    function getCampaignsByUser(address _user)
        external
        view
        returns (CampaignDetails[] memory)
    {
        return userCampaigns[_user];
    }

    function fundCampaignById(uint256 _campaignId) external payable {
        require(msg.value > 0, "Amount to fund must be greater than 0");
        CampaignDetails storage campaign = campaignLists[_campaignId];

        campaign.collectedAmount += msg.value;
        campaignLists[_campaignId].collectedAmount = campaign.collectedAmount;
        campaign.receiverAddress.transfer(msg.value);
    }
}
