import React, { useState } from 'react';
import './SearchBar.css';

function SearchBar({ onSearch }) {
  const [pokemonName, setPokemonName] = useState('');

  const handleChange = (event) => {
    setPokemonName(event.target.value);
  };

  const handleClick = () => {
    if (pokemonName.trim() !== '') { // Add this line
      onSearch(pokemonName.toLowerCase());
    }
  };

  return (
    <div style={{ textAlign: 'center' }}>
      <input 
        onChange={handleChange}
        className="search-input" 
        type="text" 
        placeholder="What Pokémon will you choose?" />
      <button onClick={handleClick} className="search-button">Search</button>
    </div>
  );
}

export default SearchBar;