class BaseConfig:
    """Base configuration"""
    FLASK_DEBUG = False
    DEBUG = False
    TESTING = False
class DevelopmentConfig(BaseConfig):
    """Development configuration"""
    FLASK_DEBUG = True
    DEBUG = True
    TESTING = True
class TestingConfig(BaseConfig):
    """Testing configuration"""
    DEBUG = True
    TESTING = True
class ProductionConfig(BaseConfig):
    """Production configuration"""
    DEBUG = False
