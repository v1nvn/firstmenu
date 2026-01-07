# ADR 003: Open-Meteo for Weather Data

## Status
Accepted

## Context
FirstMenu needs to display current weather conditions in the menu bar. Requirements:
- No API key (avoid key management/security)
- IP-based location detection
- Free for personal use
- Simple response format

## Decision
Use [Open-Meteo](https://open-meteo.com/) API:

**Features**:
- No API key required
- Free and open-source
- IP-based geolocation via `ipapi.co`
- JSON response with current weather
- WMO weather interpretation codes

**Implementation**:
```swift
// Weather endpoint
https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code&latitude=X&longitude=Y

// Location detection
https://ipapi.co/json/
```

## Rationale
1. **No Key**: Users don't need to sign up or configure anything
2. **Privacy**: IP-based location means no location permissions needed
3. **Reliability**: Open-source project with committed maintenance
4. **Caching**: 15-minute cache reduces API load

## Trade-offs
**Positive**:
- Zero configuration for users
- No API key to leak or expire
- Reasonable rate limits

**Negative**:
- No custom location support (IP-based only)
- Dependent on third-party service availability
- Limited to current weather (no forecast needed)

## Alternatives Considered
1. **WeatherKit**: Apple's official weather API
   - Rejected: Requires API key, Apple Developer account

2. **OpenWeatherMap**: Popular weather API
   - Rejected: Requires API key (even for free tier)

3. **Weather.gov**: NOAA API (US only)
   - Rejected: US-only, requires location input

## Future Enhancements
- Custom location input (lat/lon settings)
- Multiple location support
- Provider fallback list
