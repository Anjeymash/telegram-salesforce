
public with sharing class TelegramResponse {


        public class Photos {
            public String file_id;
            public String file_unique_id;
            public Integer file_size;
            public Integer width;
            public Integer height;
        }

        public Boolean ok;
        public Result result;

        public class Result {
            public Integer total_count;
            public List<List<Photos>> photos;
            public String file_id;
            public String file_unique_id;
            public Integer file_size;
            public String file_path;
        }


        public static TelegramResponse parse(String json) {
            return (TelegramResponse) System.JSON.deserialize(json, TelegramResponse.class);
        }
    }
