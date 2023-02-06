flouser=$(jq -r '.name' /1/config/user.json)
phraseeee="$flouser${flouser:0-1}${flouser:0-1}${flouser:0-1}! 🙀" && notify-send "$phraseeee" "We've found an Nintendo Switch joycon around you 👀"
#credits to character repeat: https://stackoverflow.com/questions/17542892/how-to-get-the-last-character-of-a-string-in-a-shell
