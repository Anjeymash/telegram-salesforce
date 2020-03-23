
public class TelegramWebHookResponseData {

    public Integer update_id { get; set; }
    public Message message { get; set; }

    public TelegramWebHookResponseData(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'update_id') {
                        update_id = parser.getIntegerValue();
                    } else if (text == 'message') {
                        message = new Message(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: ' + text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public class Message {
        public Integer date_Z { get; set; }
        public Chat chat { get; set; }
        public String text_Z { get; set; }
        public String message_id { get; set; }
        public From_Z from_Z { get; set; } // in json: from
        public Voice voice { get; set; }

        public Message(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'date') {
                            date_Z = parser.getIntegerValue();
                        } else if (text == 'chat') {
                            chat = new Chat(parser);
                        } else if (text == 'message_id') {
                            message_id = parser.getText();
                        } else if (text == 'from') {
                            from_Z = new From_Z(parser);
                        } else if (text == 'voice') {
                            voice = new Voice(parser);
                        } else if (text == 'text') {
                            text_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Message consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Chat {
        public String last_name { get; set; }
        public String type_Z { get; set; } // in json: type
        public String chat_id { get; set; }
        public String first_name { get; set; }
        public String username { get; set; }
        public String title { get; set; }


        public Chat(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'id') {
                            chat_id = parser.getText();
                        } else if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'username') {
                            username = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Chat consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class From_Z {
        public String last_name { get; set; }
        public String userId { get; set; }
        public String first_name { get; set; }
        public String username { get; set; }

        public From_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'id') {
                            userId = parser.getText();
                        } else if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'username') {
                            username = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'From_Z consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Voice {
        public String file_id { get; set; }
        public Integer duration { get; set; }
        public String mime_type { get; set; }
        public Integer file_size { get; set; }

        public Voice(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'file_id') {
                            file_id = parser.getText();
                        } else if (text == 'duration') {
                            duration = parser.getIntegerValue();
                        } else if (text == 'mime_type') {
                            mime_type = parser.getText();
                        } else if (text == 'file_size') {
                            file_size = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Voice consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }


    public static TelegramWebHookResponseData parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new TelegramWebHookResponseData(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }


}