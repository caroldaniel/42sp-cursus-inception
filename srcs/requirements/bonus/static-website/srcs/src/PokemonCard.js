import React from 'react';
import './PokemonCard.css';
import pokeballImage from './pokeball.png';

function getTypeColor(type) {
  const typeColors = {
    normal: "#a8a878",
    fire: "#f08030",
    water: "#6890f0",
    electric: "#f8d030",
    grass: "#78c850",
    ice: "#98d8d8",
    fighting: "#c03028",
    poison: "#a040a0",
    ground: "#e0c068",
    flying: "#a890f0",
    psychic: "#f85888",
    bug: "#a8b820",
    rock: "#b8a038",
    ghost: "#705898",
    dragon: "#7038f8",
    dark: "#705848",
    steel: "#b8b8d0",
    fairy: "#ee99ac"
  };

  return typeColors[type.toLowerCase()] || '#F5F5F5'; // default color if type is not in the map
}

function PokemonCard({ pokemonData }) {

  if (!pokemonData) {
    return (
      <div className="pokemon-card">
        <img src={pokeballImage} alt="My Image" />
      </div>
    );
  }

  // get name, type, image, hp, attack, defense, and speed from pokemonData
  const { name, types, sprites, stats } = pokemonData;
  const type = types[0].type.name;
  const image = sprites.front_default;
  const hp = stats[0].base_stat;
  const base_stats = [
    { name: 'Attack', value: stats[1].base_stat },
    { name: 'Defense', value: stats[2].base_stat },
    { name: 'Speed', value: stats[5].base_stat }
  ];
  
  const typeColor = getTypeColor(pokemonData.types[0].type.name);

  return (
    <div className="pokemon-card">
      <div className="pokemon-card-circle" style={{ backgroundColor: typeColor }}/>
      <div className="pokemon-hp-label">
        <div className="pokemon-hp-label-text">HP</div>
        <div className="pokemon-hp-value">{hp}</div>
      </div>
      <div className="pokemon-type-label" style={{ backgroundColor: typeColor }}>{type}</div>
      <div className='pokemon-name'>{name}</div>     
      <img className="pokemon-image" src={image} alt={name} />
      <div className="pokemon-stats">
        {base_stats.map((stat, index) => (
          <div key={index} className="pokemon-stat">
            <div className="pokemon-stat-value">{stat.value}</div>
            <div className="pokemon-stat-name">{stat.name}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default PokemonCard;
