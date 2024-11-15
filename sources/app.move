module decentralized_Mssg_App::Board {
    use std::string::String;
    use aptos_framework::timestamp;
    use aptos_framework::signer;
    use std::vector;

    /// Struct to store a single message
    struct Message has store, drop {
        author: address,
        content: String,
        timestamp: u64,
    }

    /// Struct to store all messages and board information
    struct MessageBoard has key {
        messages: vector<Message>,
        message_count: u64,
        max_message_length: u64,
    }

    /// Error codes
    const E_MESSAGE_TOO_LONG: u64 = 1;
    const E_BOARD_NOT_INITIALIZED: u64 = 2;

    /// Initialize a new message board
    public fun initialize_board(owner: &signer) {
        let board = MessageBoard {
            messages: vector::empty(),
            message_count: 0,
            max_message_length: 280, // Maximum message length like Twitter
        };
        move_to(owner, board);
    }

    /// Post a new message to the board
    public fun post_message(
        user: &signer,
        board_owner: address,
        content: String
    ) acquires MessageBoard {
        let board = borrow_global_mut<MessageBoard>(board_owner);
        assert!(std::string::length(&content) <= board.max_message_length, E_MESSAGE_TOO_LONG);

        let message = Message {
            author: signer::address_of(user),
            content: content,
            timestamp: timestamp::now_seconds(),
        };

        vector::push_back(&mut board.messages, message);
        board.message_count = board.message_count + 1;
    }
}