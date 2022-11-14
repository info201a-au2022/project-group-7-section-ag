# The **STAR-ting Point** for **STAR** and **EXOPLANET** Exploration!
## **Mission: Planet**

**Authors**: KelliAnn Ramirez, Salley Fang, Claire Zhang<br>
**Affiliation**: INFO-201 Technical Foundations of Informatics - The Information School - University of Washington<br>
**Date**: Autumn 2022

## **Abstract**
&emsp;We are concerned with the ***future of our planet*** and how it can be influenced by ***space exploration***. Climate changed has undoubtedly shaped the future of life on Earth and we believe with greater knowledge about stars and planets beyond our solar system, we will be able to ***prepare for life beyond Earth***. To address this concern, we plan to gather data about ***stars and exoplanets*** into a concise website that is able to filter specific information for users curious about space!

## **Keywords**
* Shaping the future
* Space exploration
* Stars and exoplanets

## **Introduction**
&emsp;***Mission: Planet*** is a project in which we look at star, exoplanet and Earth data to analyze how our species might survive beyond Earth's lifespan. On our website, we hope to have a filtering feature in which users can select certain features (e.g. temperature, distance, size) to compare exoplanets and stars with each other.<br>
&emsp;We'll look at features of habitable planets and how patterns between the planets themselves and their parent star can help us more easily identify other planets capable of sustaining human life. We will also consider the ethics behind space exploration: how it may affect views about sustainability on Earth, what we need to take into account when we arrive at another planet or encounter another civilized society of some species. Considering the possible consequences of space exploration will allow us to better prepare for our future and how life on Earth will change with greater knowledge about outer space.

## **Problem Domain**
&emsp;Our topic is about outer space, specifically how we can discover and study exoplanets and their surroundings to determine if they are habitable. Our topic concerns human well-being, as the state of Earth may affect the ability for humans to inhabit it in the future ([Vince, 2022](https://time.com/6209432/climate-change-where-we-will-live/)). <br>
&emsp;We hope to frame our project around data goals. We want to use data gathered about exoplanets and the stars they are near to find patterns in how features in one may reflect features of the other (e.g., the size of a star corresponding to a certain mass of an exoplanet nearby). We also want to include data about Earth to give users of the website an idea as to what features an exoplanet needs in order to sustain human life in the future. Lastly, we hope to touch on the ethics behind our project. There are concerns with how the search for a new planet could lead to changes in how we treat Earth and with what we should do if we encounter extraterrestrial life ([Munro, 2022](https://www.cigionline.org/articles/if-humanity-is-to-succeed-in-space-our-ethics-must-evolve/)). <br>
&emsp;Human values our topic touches on self-reliance, determination, and problem solving. Our issue we hope to help solve is one that concerns the future of the human race. The future is in our own hands and with these values in mind, we may be able to better prepare and anticipate issues for generations to come. <br>
&emsp;Direct stakeholders for our website include astronomy enthusiasts who want to learn more about exoplanets and stars, policymakers supporting the increase in space exploration and investment, and aerospace engineers and researchers, who may use our data as a starting point in creating new technologies and designs that find exoplanets and study their habitability ([Burbach, 2019](https://www.sciencedirect.com/science/article/pii/S0265964617300693)). Indirect stakeholders include citizens who may be affected by decisions made by the gov’t and policymakers who use our website. <br>

![Space Funding Spending](/data/images/space_exploration_spending.jpg)

&emsp;Harms that may come from our project largely concern the ethics behind what we hope to achieve. Encouraging the search for other habitable planets may cause people to treat Earth as disposable. Colonizing other planets with the possibility of bringing bacteria, disease, and other harmful elements should be discussed ([Dirks, 2021](https://www.scientificamerican.com/article/the-ethics-of-sending-humans-to-mars/)). Benefits from our project could include the increased interest and investment in space exploration. Preparing early for the potential relocation of humans is another benefit, as our data could be implemented to discover new exoplanets and determine their living conditions. 

## **Research Questions**
1. **Of the exoplanets we know of, what is the proportion of those exoplanets being habitable? What are some commonalities between the habitable exoplanets?**
    * Because of the strong likelihood of Earth becoming uninhabitable in the future, we need to find patterns in exoplanets that could make it liveable for humans. It is important to start this exploration process early due to the sheer number of exoplanets that have already been discovered and have yet to be discovered.
2. **How has climate change affected Earth over time (e.g., temperature, natural disasters, air quality)?**
    * This is important because climate change will eventually make Earth uninhabitable. Where will we live when that happens? Learning about outside planetary systems helps us prepare for that inevitable future.
3. **What are the ethical concerns behind space exploration?**
    * One potentially harmful mindset behind the desire for space exploration is seeing the Earth as disposable and impermanent. Will this view lead to even worse mistreatment of the Earth as people begin to see it as a temporary place to live?
4. **What happens if we encounter/discover life beyond Earth?**
    * This is important because we have to consider that we would be bringing Earth bacteria and organisms to the other planet and potentially harming the life already there. We also have to consider what to do if we find a habitable planet but another species has colonized it. Do we try to mesh ourselves into the existing society or do we wipe it out to create our own?


## **The Datasets**
&emsp;Climate change and unusual weather conditions is what motivates us to think about what’s in the future for the human species. We can use data about weather conditions to support this motivation. We can do research on what makes a planet habitable and given that information, we can look at data for different planets and determine which ones would likely be most habitable for humans. 
### ***Earth Temperatures***
&emsp;This dataset was obtained from [kaggle](https://www.kaggle.com/datasets/sevgisarac/temperature-change?select=Environment_Temperature_change_E_All_Data_NOFLAG.csv) and we fully intend on crediting the source. The dataset is named earth-land-temps.csv in our GitHub repository and has 9656 observations and 66 variables. The data was collected by NASA GISTEMP and put on kaggle by Sevgi Sy. They give credit to NASA GISTEMP on the website containing the dataset. They probably put it on kaggle because the format of NASA’s downloadable data doesn’t come out nice so they solve that issue for many people by cleaning it themselves and putting it on kaggle. NASA is governmentally funded so they get their funding from the federal government. For Sevgi Sy, they offered their own time to clean and put this dataset on kaggle. Sevgi Sy will likely make money from the dataset that’s on kaggle, but if people were to go to the NASA GISTEMP site and download it there, then NASA GISTEMP would be making the money. The data is probably somewhat trustworthy because it’s NASA GISTEMP’s data, but I don’t know who this Sevgi Sy  person is and I don’t know if some data was held back or altered in some way before publishing to kaggle.

### ***Exoplanets***
&emsp;This dataset was obtained from [kaggle](https://www.kaggle.com/datasets/sathyanarayanrao89/nasa-exoplanetary-system) and we fully intend on crediting the source. The dataset is named exoplanets.csv in our GitHub repository and has 32552 observations and 93 variables. NASA collected the data and it was put on kaggle by the user name Sathyanarayan Rao. They give credit to NASA on the website containing the dataset. They probably put it on kaggle because the format of NASA’s downloadable data doesn’t come out nice so they solve that issue for many people by cleaning it themselves and putting it on kaggle. NASA is governmentally funded so they get their funding from the federal government. For Sathyanarayan Rao, they offered their own time to clean and put this dataset on kaggle. Sathyanarayan Rao is likely to make money from the dataset that’s on kaggle, but if people were to go to the NASA site and download it there, then NASA would be making the money. The data is probably somewhat trustworthy because it’s NASA’s data, but I don’t know who this Sathyanarayan Rao person is and I don’t know if some data was held back or altered in some way before publishing to kaggle.

### ***Forest Fires in the US***
&emsp; This dataset was obtained from [kaggle](https://www.kaggle.com/datasets/chidmuthu/fires-clean) and we fully intend on crediting the source. The dataset is named fires.csv in our GitHub repository and hass 597998 observations and 20 variables. The data is an adaptation of another dataset already on kaggle and the person gives credit to that dataset. It states that the data was collected from various reporting systems at the federal, state and local level governing systems. The person, Muthu Chidambaram, seems to have put the dataset on kaggle because of some assignment for school because the requirements they need to have are in the description of the dataset. The governing systems probably had their own money to use to get and compile the original data. For Muthu Chidambaram, they offered their own time to clean and put the dataset on kaggle. They will likely make money from the dataset that’s on kaggle, but if people were to go to the original dataset on kaggle or go directly to the reporting systems and download it there, then those organizations would be making the money. The data is probably somewhat trustworthy if it’s coming from actual government organizations but I don’t know who Muthu Chidambaram is and I don’ t know if some data was held back or altered in some way before publishing to kaggle.

## **Expected Limitations**
&emsp;Assuming our research questions are answered, a possible implication for technologists could be to advance space exploration technology to utilize the features of stars to more efficiently discover new habitable exoplanets. Other features technologists may want to touch on could include analyzing certain parts of exoplanets, like surface temperature and water temperature and availability and temperature to understand how the exoplanet compares to Earth.<br>
&emsp;Designers may use research question answers in their implication of designing space exploration technology. Designers must keep certain ethics, like the mistreatment of Earth that results from finding other habitable planets and how to approach bringing human life to other planets, in mind as they create new technologies.<br>
&emsp;Lastly, expected implications of our research conclusions and answers for policymakers include policies behind the ethics of space exploration. There are a number of concerns with how knowledge we've gathered may shape perspectives on the treatment of Earth and of life outside Earth.

## **Limitations**
&emsp;Limitations we may face include not having the appropriate data to answer the questions we have posed. We might not have been able to find the data we want and that can limit the extent to which we are able to answer our research questions. We also may not be able to discuss every opinion people might have in regards to our questions. People have diverse views about all kinds of topics and we may only be able to think of and address a small portion of those perspectives. We also can only approach the questions based on our own background and knowledge. We are not astronomy experts so what we know and say as a result is limited. We also are not fortune tellers who can see the future so what we say may not end up being true or actually happen. We just propose what we think is likely to happen based on the data we have collected.

## **Acknowledgements**
Thank you to kaggle.com for providing a majority of our data and making it simple to view and open on RStudio!<br>
We would also like to thank Rona, our TA, for answering our questions during section, office hours, and Teams!

## **References**
* Burbach, David T. “Partisan Rationales for Space: Motivations for Public Support of Space Exploration Funding, 1973–2016.” Space Policy, vol. 50, 2019, p. 101331., https://doi.org/10.1016/j.spacepol.2019.08.001. 
* Dirks, Nicholas. “The Ethics of Sending Humans to Mars.” Scientific American, 10 Aug. 2021, https://www.scientificamerican.com/article/the-ethics-of-sending-humans-to-mars/. 
* Munro, Daniel. “If Humanity Is to Succeed in Space, Our Ethics Must Evolve.” Centre for International Governance Innovation, 4 Apr. 2022, https://www.cigionline.org/articles/if-humanity-is-to-succeed-in-space-our-ethics-must-evolve/. 
* Vince, Gaia. “Where We'll End Up Living as the Planet Burns.” Time, 31 Aug. 2022, https://time.com/6209432/climate-change-where-we-will-live/. 

## **Appendix A: Questions**
* Is our topic a good topic?
* Is it okay for the topic to be a bit more broad and have multiple topic goals?
* Can we make slight alterations to our topic later if we discover we want to include something not mentioned here or get rid of something?