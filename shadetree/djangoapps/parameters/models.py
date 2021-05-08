from django.db import models
from model_utils.models import StatusModel, TimeStampedModel
from model_utils import Choices

class HierarchialPublicationBaseClass(StatusModel, TimeStampedModel):
    STATUS = Choices('draft', 'review', 'published')
    name = models.CharField(max_length=50)
    parent = models.ForeignKey("self", null=True, on_delete=models.CASCADE)


class Project(HierarchialPublicationBaseClass):
    #slug = models.SlugField(max_length = 200)
    url = models.URLField(max_length=200)

"""
Package Classes
"""
class Package(HierarchialPublicationBaseClass):
    """Base case for software packages: Application, Service, Framework, Project
    """
    parent_project = models.ForeignKey(Project, null=True, on_delete=models.CASCADE)

    # fix me
    package_type = models.CharField(max_length=50)


"""
Module Classes
"""
class Module(HierarchialPublicationBaseClass):
    parent_package = models.ForeignKey(Package, null=True, on_delete=models.CASCADE)


"""
Parameter Classes
"""
class Parameter(HierarchialPublicationBaseClass):
    parent_module = models.ForeignKey(Module, null=True, on_delete=models.CASCADE)
