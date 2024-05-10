// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amounCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];
        require(campaign.deadline < block.timestamp ,"Deadline should be date in future");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amounCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns-1; 
    }


    function donateToCampaign(uint256 _id) public payable{
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];
        campaign.donations.push(amount);
        campaign.donators.push(msg.sender);

        //money beign send to campain owners wallet
        (bool callSuccess,) = payable(campaign.owner).call{value : amount}("");

        if(callSuccess){
            campaign.amounCollected = campaign.amounCollected + amount;
        }

    }

    function getDonators(uint256 _id) public view returns(address[] memory , uint256[] memory) {
        return (campaigns[_id].donators , campaigns[_id].donations);
    }

    function getCampaigns() public view returns(Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i=0;i<numberOfCampaigns;i++){
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;

    }
}
