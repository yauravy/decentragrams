pragma solidity ^0.5.0;

contract Decentragram {
    string public name = "decentragram";

    // store images
    uint256 public imageCount = 0;
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // create images
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        //make sure image hash exists
        require(bytes(_imgHash).length > 0);

        // make sure image description exists
        require(bytes(_description).length > 0);

        // make sure iploader address exists
        require(msg.sender != address(0x0));

        //increment image id
        imageCount++;

        //add image to contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        // trigger an event
        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    // tip images
    function tipImageOwner(uint256 _id) public payable {
        //make sure the id is valid
        require(_id > 0 && _id <= imageCount);

        //fetch the image
        Image memory _image = images[_id];

        // fetch the author
        address payable _author = _image.author;

        //pay the author by sending them ether
        address(_author).transfer(msg.value);

        //increment the tipAmount
        _image.tipAmount = _image.tipAmount + msg.value;

        // update the image
        images[_id] = _image;

        // trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
