package main

import (
    "fmt"
    "strings"
)

type RecommendMovie interface {
    getDetail()
    searchByGenre(genre string)
    searchByRating(rating float64)
}


type Movie struct {
    name string
    year int
    genre string
    rating float64
}
func (m *Movie) getDetail(){
    fmt.Println(fmt.Sprintf("MOVIE: %s (%d) - %s, %.1f", m.name, m.year, m.genre, m.rating))
}
func (m *Movie) searchByGenre(genre string) {
    if strings.EqualFold(m.genre, genre){
        m.getDetail()
    }
}
func (m *Movie) searchByRating(rating float64) {
    if m.rating >= rating {
        m.getDetail()
    }
}


type MovieGroup struct {
    title string
    recommend []RecommendMovie
}
func (g *MovieGroup) add(movie RecommendMovie) {
    g.recommend = append(g.recommend, movie)
}
func (g *MovieGroup) getDetail(){
    fmt.Println(g.title + "group")
    for _, movie := range g.recommend {
        movie.getDetail()
    }
}
func (g *MovieGroup) searchByGenre(genre string) {
    for _, movie := range g.recommend {
        movie.searchByGenre(genre)
    }
}
func (g *MovieGroup) searchByRating(rating float64) {
    for _, movie := range g.recommend {
        movie.searchByRating(rating)
    }
}


func main() {
    movie1 := &Movie{name: "Interstellar", year: 2014, genre: "Sci-Fi", rating: 8.6}
	movie2 := &Movie{name: "Inception", year: 2010, genre: "Sci-Fi", rating: 8.8}
	movie3 := &Movie{name: "Tenet", year: 2020, genre: "Action", rating: 7.5}
	movie4 := &Movie{name: "The Matrix", year: 1999, genre: "Sci-Fi", rating: 8.7}
	movie5 := &Movie{name: "Shutter Island", year: 2010, genre: "Thriller", rating: 8.2}
	
	sci_fiGroup := &MovieGroup{title:"Sci-Fi Group"}
	sci_fiGroup.add(movie1)
	sci_fiGroup.add(movie2)
	sci_fiGroup.add(movie4)
	sci_fiGroup.getDetail()
	
	recGroup := &MovieGroup{title:"Recommend Group"}
	recGroup.add(sci_fiGroup)
	recGroup.add(movie3)
	recGroup.add(movie5)
	fmt.Println("\n\n")
	recGroup.getDetail()
	
	fmt.Println("\nsearch genre = Action")
	recGroup.searchByGenre("Action")

	fmt.Println("\nsearch rating more than 8.5")
	recGroup.searchByRating(8.5)
}