//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SMECollaboration {
    struct Project {
        string name;
        address owner;
        uint256 fundingGoal;
        uint256 currentFunding;
        bool isActive;
    }

    mapping(uint256 => Project) public projects;
    uint256 public projectCount;

    event ProjectCreated(uint256 projectId, string name, address owner, uint256 fundingGoal);
    event ProjectFunded(uint256 projectId, address funder, uint256 amount);

    function createProject(string memory _name, uint256 _fundingGoal) public {
        projectCount++;
        projects[projectCount] = Project(_name, msg.sender, _fundingGoal, 0, true);
        emit ProjectCreated(projectCount, _name, msg.sender, _fundingGoal);
    }

    function fundProject(uint256 _projectId) public payable {
        Project storage project = projects[_projectId];
        require(project.isActive, "Project is not active");
        require(msg.value > 0, "Funding amount must be greater than 0");

        project.currentFunding += msg.value;
        emit ProjectFunded(_projectId, msg.sender, msg.value);

        if (project.currentFunding >= project.fundingGoal) {
            project.isActive = false;
        }
    }
}