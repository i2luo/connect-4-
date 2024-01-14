import java.util.*;

public class MyProgram
{
    public static ArrayList<String> colors = new ArrayList<String>();
    public static ArrayList<String> user = new ArrayList<String>();
    public static ArrayList<String> bot = new ArrayList<String>();
    public static ArrayList<String> pile = new ArrayList<String>();
    public static boolean skip_turn = false;
    
    public static void main(String[] args)
    {
        Scanner scanner = new Scanner(System.in);
        //Set up
        colors.add("red");
        colors.add("blue");
        colors.add("green");
        colors.add("yellow");
        String nums = "0123456789";
        
        System.out.println("A few notes before the games starts:");
        System.out.println("");
        System.out.println("1. If you have two cards left and are about to place one of them, after entering 'y' to being prompted if you would like to place a card you will have 3 seconds to type 'uno'. Otherwise, you will draw 2 cards and your turn will be skipped.");
        System.out.println("");
        System.out.println("2. If the card in the pile ends with a 'z' you may place any card that matches its color. For example, if the pile is a 'blue z' you may place any blue card (or wild card).");
        System.out.println("");
        System.out.println("3. If you have any questions about the rules of the game, please copy & paste this url into your search bar 'https://www.unorules.com/'");
        System.out.println(""); 
        System.out.println("Good luck!");
        
        //Bot and user draws 7 cards
        for (int i = 0; i < 7; i++)
        {
            bot.add(generate_card());
            user.add(generate_card());
        }
        
        //Generating a valid start card
        while (true)
        {
            String start = generate_card();
            if (nums.indexOf(start.substring(start.length()-1)) > -1)
            {
                pile.add(start);
                break;
            }
        }
        
        //User and bot take turns playing cards until one wins
        while (true)
        {
            Collections.sort(user);
            Collections.sort(bot);
            if (!(skip_turn))
            {
                user_turn();
            }
            else
            {
                System.out.println("Your turn has been skipped.");
                System.out.println("");
                skip_turn = false;
            }
            if (user.size() == 0)
            {
                System.out.println("Congratulations you've won!");
                break;
            }
            if (!(skip_turn))
            {
                bot_turn();
            }
            else
            {
                System.out.println("Bot's turn has been skipped.");
                System.out.println("");
                skip_turn = false;
            }
            if (bot.size() == 0)
            {
                System.out.println("Imagine losing to a bot.");
                break;
            }
            
        }
    }
    
    // Function for generating a random card
    public static String generate_card()
    {
        int rand1 = (int)(Math.random()*17);
        int rand2 = (int)(Math.random()*4);
        
        if (rand1 < 10)
        {
            return colors.get(rand2) + " " + rand1;
        }
        if (rand1 == 10)
        {
            return colors.get(rand2) + " draw two";
        }
        if (rand1 == 11)
        {
            return colors.get(rand2) + " skip";
        }
        if (rand1 == 12)
        {
            return colors.get(rand2) + " reverse";
        }
        if (rand1 < 15)
        {
            return "wild";
        }
        if (rand1 < 17)
        {
            return "wild draw four";
        }
        return "";
    }
    
    // Function for checking if a card is valid to place on pile
    public static boolean valid_card(String card)
    {
        if (card.equals("wild") || card.equals("wild draw four"))
        {
            return true;
        }
        if (card.substring(0,card.indexOf(" ")).equals(pile.get(0).substring(0,pile.get(0).indexOf(" "))))
        {
            return true;
        }
        if (card.substring(card.length()-1).equals(pile.get(0).substring(pile.get(0).length()-1)))
        {
            return true;
        }
        return false;
    }
    
    // Function for placing a card on pile
    public static String place_card(int num, String card)
    {
        Scanner scanner = new Scanner(System.in);
        if (card.indexOf("draw two")>-1)
        {
            if(num == 1)
            {
                bot.add(generate_card());
                bot.add(generate_card());
                skip_turn = true;
            }
            if(num == 2)
            {
                user.add(generate_card());
                user.add(generate_card());
                skip_turn = true;
            }
        }
        if (card.indexOf("draw four")>-1)
        {
            if(num == 1)
            {
                for (int i = 0;i < 4;i++)
                {
                    bot.add(generate_card());
                }
                skip_turn = true;
            }
            if(num == 2)
            {
                for (int j = 0;j < 4;j++)
                {
                    user.add(generate_card());
                }
                skip_turn = true;
            }
        }
        if (card.indexOf("skip")>-1)
        {
            skip_turn = true;
        }
        if (card.indexOf("wild")>-1)
        {
            if (num == 1)
            {
                System.out.println("What would you like to change the color being played to?");
                String color_change = scanner.nextLine();
                while(true)
                {
                    if(colors.contains(color_change))
                    {
                        break;
                    }
                    else
                    {
                        System.out.println("That was not a valid answer. Please type in a valid color.");
                        color_change = scanner.nextLine();
                    }
                }
                return color_change + " z";
            }
            if (num == 2)
            {
                for (int k=0; k < bot.size(); k++)
                {
                    if (bot.get(k).indexOf("wild") == -1)
                    {
                        return bot.get(k).substring(0,bot.get(k).indexOf(" ")) + " z";
                    }
                }
                return "yellow z";
            }
        }
        return card;
    }
    
    // Function for user's turn
    public static void user_turn()
    {
        Scanner scanner = new Scanner(System.in);
        System.out.println("---------------------------------------------------------");
        System.out.println("Pile: " + pile);
        System.out.println("User's turn.");
        System.out.println("Your hand:");
        System.out.println(user);
        System.out.println("Would you like to draw a card? type 'y' or 'n'.");
        String draw_card = scanner.nextLine();
        while(true)
        {
            if (draw_card.equals("y"))
            {
                String newCard = generate_card();
                user.add(newCard);
                System.out.println("User drew " + newCard);
                Collections.sort(user);
                System.out.println("Your hand:");
                System.out.println(user);
                break;
            }
            else if (draw_card.equals("n"))
            {
                break;
            }
            else
            {
                System.out.println("That was not a valid answer. Please type 'y' or 'n'.");
                draw_card = scanner.nextLine();
            }
        }
        
        System.out.println("Would you like to place a card? type 'y' or 'n'.");
        String place_card = scanner.nextLine();
        while(true)
        {
            if (place_card.equals("y"))
            {
                if(user.size() == 2)
                {
                    long start = System.currentTimeMillis();
                    String uno = scanner.nextLine();
                    long end = System.currentTimeMillis();
                    if (end-start > 3000)
                    {
                        System.out.println("You took too long to type 'uno'. Two cards have been added to your hand.");
                        for(int i = 0; i < 2; i++)
                        {
                            user.add(generate_card());
                        }
                        System.out.println("Your hand:");
                        System.out.println(user);
                        break;
                    }
                    else if (!(uno.equals("uno")))
                    {
                        System.out.println("That was not 'uno'. Two cards have been added to your hand.");
                        for(int i = 0; i < 2; i++)
                        {
                            user.add(generate_card());
                        }
                        System.out.println("Your hand:");
                        System.out.println(user);
                        break;
                    }
                }
                System.out.println("Please type out the card you would like to place as it appears in your hand.");
                String selected_card = scanner.nextLine();
                while(true)
                {
                    if (user.contains(selected_card) && valid_card(selected_card))
                    {
                        pile.remove(0);
                        pile.add(place_card(1,selected_card));
                        int r = user.indexOf(selected_card);
                        user.remove(r);
                        break;
                    }
                    else
                    {
                        System.out.println("That was not a valid answer. Please type in a valid card as it appears in your hand.");
                        selected_card = scanner.nextLine();
                    }
                    
                }
                break;
            }
            else if (place_card.equals("n"))
            {
                break;
            }
            else
            {
                System.out.println("That was not a valid answer. Please type 'y' or 'n'.");
                place_card = scanner.nextLine();
            }
        }
        System.out.println("---------------------------------------------------------");
        System.out.println("");
    }
    
    // Function for bot's turn
    public static void bot_turn()
    {
        System.out.println("---------------------------------------------------------");
        System.out.println("Bot's turn.");
        boolean draw = true;
        for (int i = 0; i < bot.size(); i++)
        {
            if (valid_card(bot.get(i)))
            {
                pile.remove(0);
                pile.add(place_card(2,bot.get(i)));
                System.out.println("Bot has placed " + bot.get(i));
                int r = bot.indexOf(bot.get(i));
                bot.remove(r);
                draw = false;
                break;
            }
        }
        if (draw)
        {
            bot.add(generate_card());
        }
        if (bot.size()==1)
        {
            System.out.println("uno");
        }
        System.out.println("Bot has " + bot.size() + " cards left");
        System.out.println("---------------------------------------------------------");
        System.out.println("");
    }
}
